import os
import xml.etree.ElementTree as ET
import json
import subprocess
import shutil
import logging

SETTINGS_FILE = "settings.json"

# Configure logging to write to both console and file
logging.basicConfig(level=logging.INFO, 
                    format='%(message)s', 
                    handlers=[
                        logging.FileHandler("output.log", mode='w'),
                        logging.StreamHandler()
                    ])

def get_directory(prompt):
    response = input(prompt)
    return response

def setup_settings():
    settings = {}
    if not os.path.exists(SETTINGS_FILE):
        logging.info("Creating Settings...")
        
        default_content_path = os.path.join(os.environ['USERPROFILE'], 'Documents', 'Egosoft', 'X4', '25506413', 'content.xml')
        settings['primary_content'] = get_directory(f"Enter path to primary content.xml (default: {default_content_path}): ") or default_content_path
        logging.info(f"  primary_content: {settings['primary_content']}")
        
        settings['vanilla_folder'] = get_directory("Enter path to the extracted vanilla folder: ")
        logging.info(f"  vanilla_folder: {settings['vanilla_folder']}")

        # Check for diff.xsd
        expected_diff_path = os.path.join(settings['vanilla_folder'], 'libraries', 'diff.xsd')
        if os.path.exists(expected_diff_path):
            settings['diff.xsd'] = expected_diff_path
        else:
            settings['diff.xsd'] = get_directory("Enter path to diff.xsd (not found in expected location): ")
        logging.info(f"  diff.xsd: {settings['diff.xsd']}")
        
        settings['extensions_folder'] = get_directory("Enter path to the extensions folder: ")
        logging.info(f"  extensions_folder: {settings['extensions_folder']}")
        settings['output_folder'] = "output"
        logging.info(f"  output_folder: {settings['output_folder']}")
        
        # Create settings.json file
        with open(SETTINGS_FILE, 'w') as f:
            json.dump(settings, f, indent=4, ensure_ascii=False)
    else:
        with open(SETTINGS_FILE, 'r') as f:
            settings = json.load(f)
        logging.info("Loaded existing settings:")
        logging.info(f"  primary_content: {settings['primary_content']}")
        logging.info(f"  vanilla_folder: {settings['vanilla_folder']}")
        logging.info(f"  diff.xsd: {settings['diff.xsd']}")
        logging.info(f"  extensions_folder: {settings['extensions_folder']}")
        logging.info(f"  output_folder: {settings['output_folder']}")
    
    return settings

def ensure_directory_exists(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)

def parse_xml(file_path):
    tree = ET.parse(file_path)
    root = tree.getroot()
    return root

def collect_extensions_and_dependencies(extensions_folder):
    extensions = {}
    logging.info("\ninfo: collect_extensions_and_dependencies:")
    for root, dirs, files in os.walk(extensions_folder):
        if 'content.xml' in files:
            content_path = os.path.join(root, 'content.xml')
            content = parse_xml(content_path)
            ext_id = content.get('id')
            logging.info(f"  {ext_id}")
            
            dependencies = []
            for dep in content.findall('dependency'):
                dep_id = dep.get('id')
                if dep_id is None:
                    continue
                optional = dep.get('optional', 'false') == 'true'
                dependencies.append({
                    'id': dep_id,
                    'optional': optional
                })
                logging.info(f"    {dep_id} opt: {optional}")
            extensions[ext_id] = {'path': root, 'dependencies': dependencies}
    return extensions

def sort_extensions(extensions, primary_content):
    enabled_extensions = {ext.get('id') for ext in primary_content.findall('extension') if ext.get('enabled') == 'true'}

    # Add special DLCs to enabled_extensions if they exist in extensions
    special_dlcs = {'ego_dlc_split', 'ego_dlc_terran', 'ego_dlc_pirate', 'ego_dlc_boron', 'ego_dlc_timelines'}
    enabled_extensions.update(special_dlcs.intersection(extensions.keys()))

    logging.info("\ninfo: enabled_extensions:")
    for ext_id in enabled_extensions:
        logging.info(f"  {ext_id}")

    
    # Filter out extensions that are not enabled in primary content.xml
    relevant_extensions = {ext_id: ext for ext_id, ext in extensions.items() if ext_id in enabled_extensions}
    
    sorted_extensions = []
    remaining_extensions = list(relevant_extensions.keys())
    
    max_iterations = len(remaining_extensions) * 5  
    iteration = 0

    while remaining_extensions and iteration < max_iterations:
        iteration += 1
        for ext_id in remaining_extensions[:]:
            ext_dependencies = relevant_extensions[ext_id]['dependencies']
            # Check if all required dependencies are met
            if all(dep['id'] in enabled_extensions for dep in ext_dependencies if not dep['optional']):
                # Check if all dependencies (required or optional) are either sorted or not relevant
                if all(dep['id'] in sorted_extensions or dep['id'] not in relevant_extensions for dep in ext_dependencies):
                    sorted_extensions.append(ext_id)
                    remaining_extensions.remove(ext_id)

    if remaining_extensions:
        logging.warning("\nwarning: Some extensions could not be sorted due to unresolved dependencies. Remaining:")
        for ext_id in remaining_extensions:
            logging.warning(f" - {ext_id}")
            ext_dependencies = relevant_extensions[ext_id]['dependencies']
            missing_dependencies = []
            unsorted_or_disabled_dependencies = []

            for dep in ext_dependencies:
                if dep['id'] not in extensions:  
                    missing_dependencies.append(dep['id'])
                elif dep['id'] not in relevant_extensions: 
                    unsorted_or_disabled_dependencies.append(dep['id'])
                elif dep['id'] not in sorted_extensions:  
                    unsorted_or_disabled_dependencies.append(dep['id'])

            if missing_dependencies:
                logging.warning(f"   Entirely missing dependencies: {missing_dependencies}")
            if unsorted_or_disabled_dependencies:
                logging.warning(f"   Dependencies not sorted or disabled: {unsorted_or_disabled_dependencies}")
            else:
                logging.warning("   No missing direct dependencies, but might be part of a cycle or have indirect dependency issues.")

    final_order = []
    max_iterations = len(sorted_extensions) * 5  
    iteration = 0

    while sorted_extensions and iteration < max_iterations:
        iteration += 1
        for i, ext_id in enumerate(sorted_extensions):
            ext_dependencies = relevant_extensions[ext_id]['dependencies']
            required_deps = [dep['id'] for dep in ext_dependencies if not dep['optional']]
            optional_deps = [dep['id'] for dep in ext_dependencies if dep['optional']]
            
            if all(dep['id'] in final_order or dep['id'] not in relevant_extensions for dep in ext_dependencies):
                # Check for optional dependencies with greater index
                for opt_dep in optional_deps:
                    if opt_dep in sorted_extensions and sorted_extensions.index(opt_dep) > i:
                        sorted_extensions.pop(i)  
                        sorted_extensions.append(ext_id)
                        break
                else:
                    final_order.append(ext_id)
                    sorted_extensions.pop(i)
                    break

    if sorted_extensions:
        logging.warning("\nwarning: Some extensions could not be sorted due to unresolved dependencies. Remaining:")
        for ext_id in sorted_extensions:
            logging.warning(f" - {ext_id}")

    logging.info("\ninfo: final_order:")
    for ext_id in final_order:
        ext = relevant_extensions[ext_id]
        required = [dep['id'] for dep in ext['dependencies'] if not dep['optional']]
        optional = [dep['id'] for dep in ext['dependencies'] if dep['optional']]
        logging.info(f"  {ext_id}" + (f" req: {required}" if required else "") + (f"  opt: {optional}" if optional else ""))

    return [relevant_extensions[ext_id] for ext_id in final_order]

def run_script(source, extension, output):
    command = f'XMLPatch -o "{source}" -d "{extension}" -u "{output}" -x "{settings['diff.xsd']}"'
    
    logging.info(f"Running command: {command}")
    try:
        process = subprocess.Popen(command, shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
        stdout, stderr = process.communicate()
        if stdout:
            logging.info(stdout)
        if stderr:
            logging.error(stderr)
        process.wait()
        if process.returncode != 0:
            raise subprocess.CalledProcessError(process.returncode, command)
    except subprocess.CalledProcessError as e:
        logging.error(f"Command '{e.cmd}' returned non-zero exit status {e.returncode}")

def copy_directory(src, dest):    
    for root, _, files in os.walk(src):
        for file in files:
            if file.endswith('.xml'):
                src_file = os.path.join(root, file)
                rel_path = os.path.relpath(root, src)
                dest_path = os.path.join(dest, rel_path.lower().replace('extensions', 'extensions'))
                ensure_directory_exists(dest_path)
                shutil.copy2(src_file, dest_path)

def process_extensions(settings):
    primary_content = parse_xml(settings['primary_content'])
    all_extensions = collect_extensions_and_dependencies(settings['extensions_folder'])
    sorted_extensions = sort_extensions(all_extensions, primary_content)
   
    # Ensure temp directories exist
    temp_source = "temp_source"
    shutil.rmtree(temp_source, ignore_errors=True)
    ensure_directory_exists(temp_source)
    
    temp_output = "temp_output"
    
    output = settings['output_folder']
    shutil.rmtree(output, ignore_errors=True)
    ensure_directory_exists(output)

    # Initial copy from vanilla folder
    copy_directory(settings['vanilla_folder'], temp_source)

    for i, ext in enumerate(sorted_extensions):
        shutil.rmtree(temp_output, ignore_errors=True)
        ensure_directory_exists(temp_output)

        # Add extensions files to temp_source
        extension_dir = ext['path'].split(settings['extensions_folder'])[1].strip(os.path.sep)
        ext_temp_path = os.path.join(temp_source, 'extensions', extension_dir.lower().replace('extensions', 'extensions'))
        ensure_directory_exists(ext_temp_path)
        copy_directory(ext['path'], ext_temp_path)

        # Copy current state to temp_source before applying patches, but only after the first run
        if i > 0:
            copy_directory(output, temp_source)  
        
        # Run the script using temp_output as the immediate output
        logging.info(f"\nProcessing extension: {ext}")
        run_script(temp_source, ext['path'], temp_output)
        
        # Update the final output with the current execution's temp_output
        copy_directory(temp_output, output)

    shutil.rmtree(temp_source, ignore_errors=True)
    shutil.rmtree(temp_output, ignore_errors=True)

if __name__ == "__main__":
    settings = setup_settings()
    process_extensions(settings)