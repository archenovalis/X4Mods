// compileMod.ts
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
  return new Promise((resolve) => {
    zlib.gzip(buffer, (err, compressedData) => {
      if (err) {
        throw(`Error compressing file: ${err}`);
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
      // Recursively add files from subdirectories
      await addFilesToZip(projectFolder, zip, itemPath, baseDir, allowedExtensions);
    } else if (stats.isFile() && allowedExtensions.includes(ext)) {
      let relativePath = `${projectFolder}/${relative(baseDir, itemPath)}`;
      if (itemPath.endsWith('.xml')) {
        // Clean schema location
        let xml = readFileSync(itemPath, 'utf8');
        // check xml second line for <type>
        function type(xml: string) {
          xml.replace('\r', '')
          return xml.match(/\s*?<diff>\s*?$/)
        }
        if (type(xml)) xml.replace(/SchemaLocation\=\"\.\.\/.*xsd\/.*\.xsd/g, 'SchemaLocation="diff.xsd');
        else  xml.replace(/SchemaLocation\=\"\.\.\/.*xsd\//g, 'SchemaLocation="');
        zip.file(relativePath, xml);
      } else if (itemPath.endsWith('.tga')) {
        // Gzip and add .tga files
        relativePath = relativePath.replace('.tga', '.gz');
        zip.file(relativePath, await gzip(readFileSync(itemPath)));
      } else {
        // Add other files as is
        zip.file(relativePath, readFileSync(itemPath));
      }
    }
  }
};

// Main function to create the zip file
const createZip = async (projectFolder: string, sourceDir: string, version: string, allowedExtensions: string[]) => {
  const dateTime = new Date().toISOString().replace(/[:.-]/g, '_');
  const outDir = resolve(__dirname, 'dist');
  const outputZip = `${outDir}/${projectFolder}-v${version}-${dateTime.split('T')[0]}.zip`;

  const zip = new JSZip();
  await addFilesToZip(projectFolder, zip, sourceDir, sourceDir, allowedExtensions);

  const zipData = await zip.generateAsync({ type: 'nodebuffer', compression: 'DEFLATE', compressionOptions: { level: 9 } });

  // Write the generated zip file to disk
  writeFileSync(outputZip, zipData);
  console.log(`Archive created successfully: ${outputZip}`);
};

const run = async () => {
  const projectFolder = process.argv[2];
  if (!projectFolder) {
    console.error('Please provide the project folder as an argument.');
    process.exit(1);
  }

  try {
    const path = projectPath(projectFolder);
    const version = await getVersionFromContentXml(path);
    const allowedExtensions = getAllowedExtensions(path);
    await createZip(projectFolder, path, version, allowedExtensions);
  } catch (error) {
    console.error(`Error: ${error}`);
  }
};

run();
