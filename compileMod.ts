import { existsSync, readFileSync, readdirSync, statSync, writeFileSync } from 'fs';
import { extname, relative, resolve } from 'path';
import { Parser } from 'xml2js';
import zlib from 'zlib';
import JSZip from 'jszip';

const parser = new Parser();

const getAllowedExtensions = (projectPath: string): string[] => {
  const configPath = resolve(projectPath, 'allowedExtensions');
  
  if (existsSync(configPath)) {
    const config = JSON.parse(readFileSync(configPath, 'utf-8'));
    if (config.filetypes) {
      return config.filetypes || ['.xml'];
    }
    else {
      throw new Error('allowedExtensions file error');
    }
  } else {
    return ['.xml'];
  }
};

const projectPath = (projectFolder: string) => resolve(__dirname, projectFolder);

const getVersionFromContentXml = async (path: string): Promise<string> => {
  const xml = readFileSync(path+'/content.xml', 'utf8');

  try {
    const result = await parser.parseStringPromise(xml);
    return result['content']['$']['version'];
  } catch (error) {
    throw new Error(`Error parsing XML: ${error}`);
  }
};

const gzip = (buffer: Buffer): Promise<Buffer> => {
  return new Promise((resolve, reject) => {
    zlib.gzip(buffer, (err, compressedData) => {
      if (err) {
        reject(`Error compressing file: ${err}`);
      } else {
        resolve(compressedData);
      }
    });
  });
};

const addFilesToZip = async (projectFolder: string, zip: JSZip, dir: string, baseDir: string, allowedExtensions: string[]) => {
  const items = readdirSync(dir);

  for (const item of items) {
    const itemPath = resolve(dir, item);
    const stats = statSync(itemPath);
    const ext = extname(itemPath).toLowerCase();
    
    if (stats.isDirectory()) {
      await addFilesToZip(projectFolder, zip, itemPath, baseDir, allowedExtensions);
    } else if (stats.isFile() && allowedExtensions.includes(ext)) {
      let relativePath = `${projectFolder}/${relative(baseDir, itemPath)}`;
      if (itemPath.endsWith('.xml')) {
        const xml = readFileSync(itemPath, 'utf8').replace(/SchemaLocation\=\"\.\.\/.*xsd\//g, 'SchemaLocation="');
        zip.file(relativePath, xml);
      } else if (itemPath.endsWith('.tga')) {
        relativePath = relativePath.replace('.tga', '.gz');
        zip.file(relativePath, await gzip(readFileSync(itemPath)));
      } else {
        zip.file(relativePath, readFileSync(itemPath));
      }
    }
  }
};

const createZip = async (projectFolders: string[], version: string, allowedExtensions: string[]) => {
  const dateTime = new Date().toISOString().replace(/[:.-]/g, '_');
  const outDir = resolve(__dirname, 'dist');
  const baseProjectFolder = projectFolders[0];  // Use the first folder name for the zip filename
  const outputZip = `${outDir}/${baseProjectFolder}-v${version}-${dateTime.split('T')[0]}.zip`;

  const zip = new JSZip();

  for (const projectFolder of projectFolders) {
    const path = projectPath(projectFolder);
    await addFilesToZip(projectFolder, zip, path, path, allowedExtensions);
  }

  const zipData = await zip.generateAsync({ type: 'nodebuffer', compression: 'DEFLATE', compressionOptions: { level: 9 } });

  writeFileSync(outputZip, zipData);
  console.log(`Archive created successfully: ${outputZip}`);
};

const run = async () => {
  const projectFolders = process.argv.slice(2);
  if (projectFolders.length === 0) {
    console.error('Please provide at least one project folder as an argument.');
    process.exit(1);
  }

  try {
    const basePath = projectPath(projectFolders[0]);
    const version = await getVersionFromContentXml(basePath);
    const allowedExtensions = getAllowedExtensions(basePath);
    await createZip(projectFolders, version, allowedExtensions);
  } catch (error) {
    console.error(`Error: ${error}`);
  }
};

run();