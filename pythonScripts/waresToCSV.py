import xml.etree.ElementTree as ET
import csv
from io import StringIO

input_file = 'wares.xml'
output_file = 'wares.csv'

def parse_xml_to_csv(xml_string):
    # Parse XML
    root = ET.fromstring(xml_string)
    
    # Prepare CSV output
    output = StringIO()
    writer = csv.writer(output, lineterminator='\n')
    
    # Define headers
    headers = [
        'type', 'id', 'name', 'description', 'group', 'transport', 'volume', 'tags', 'sortorder',
        'price_min', 'price_average', 'price_max',
        'production_times', 'production_amounts', 'production_methods', 'primary_resources_list',
        'research_time', 'research_resources',
        'owner_factions', 'icon_active', 'icon_video', 'container_ref'
    ]
    writer.writerow(headers)
    
    # Handle the top-level <production> node
    production_node = root.find('production')
    if production_node is not None:
        for method in production_node.findall('method'):
            method_data = {
                'type': 'production',
                'id': method.get('id', ''),
                'name': method.get('name', ''),
                'description': '',
                'group': '',
                'transport': '',
                'volume': '',
                'tags': method.get('tags', ''),
                'sortorder': '',
                'price_min': '',
                'price_average': '',
                'price_max': '',
                'production_times': '',
                'production_amounts': '',
                'production_methods': method.get('id', ''),
                'primary_resources_list': '',
                'research_time': '',
                'research_resources': '',
                'owner_factions': '',
                'icon_active': '',
                'icon_video': '',
                'container_ref': ''
            }
            if method_data['id']:
                writer.writerow([method_data[key] for key in headers])
    
    # Handle the <defaults> node
    defaults_node = root.find('defaults')
    if defaults_node is not None:
        defaults_data = {
            'type': 'defaults',
            'id': defaults_node.get('id', ''),
            'name': defaults_node.get('name', ''),
            'description': '',
            'group': '',
            'transport': defaults_node.get('transport', ''),
            'volume': defaults_node.get('volume', ''),
            'tags': defaults_node.get('tags', ''),
            'sortorder': '',
            'price_min': '',
            'price_average': '',
            'price_max': '',
            'production_times': '',
            'production_amounts': '',
            'production_methods': '',
            'primary_resources_list': '',
            'research_time': '',
            'research_resources': '',
            'owner_factions': '',
            'icon_active': '',
            'icon_video': '',
            'container_ref': ''
        }
        price = defaults_node.find('price')
        if price is not None:
            defaults_data['price_min'] = price.get('min', '')
            defaults_data['price_average'] = price.get('average', '')
            defaults_data['price_max'] = price.get('max', '')
        production = defaults_node.find('production')
        if production is not None:
            defaults_data['production_times'] = production.get('time', '')
            defaults_data['production_amounts'] = production.get('amount', '')
            defaults_data['production_methods'] = production.get('method', '')
        icon = defaults_node.find('icon')
        if icon is not None:
            defaults_data['icon_active'] = icon.get('active', '')
            defaults_data['icon_video'] = icon.get('video', '')
        container = defaults_node.find('container')
        if container is not None:
            defaults_data['container_ref'] = container.get('ref', '')

        if defaults_data['id']:
            writer.writerow([defaults_data[key] for key in headers])
    
    # Process each ware
    for ware in root.findall('.//ware'):
        ware_data = {
            'type': 'ware',
            'id': ware.get('id', ''),
            'name': ware.get('name', ''),
            'description': ware.get('description', ''),
            'group': ware.get('group', ''),
            'transport': ware.get('transport', ''),
            'volume': ware.get('volume', ''),
            'tags': ware.get('tags', ''),
            'sortorder': ware.get('sortorder', ''),
            'price_min': '',
            'price_average': '',
            'price_max': '',
            'production_times': '',
            'production_amounts': '',
            'production_methods': '',
            'primary_resources_list': '',
            'research_time': '',
            'research_resources': '',
            'owner_factions': '',
            'icon_active': '',
            'icon_video': '',
            'container_ref': ''
        }
        
        # Get price information
        price = ware.find('price')
        if price is not None:
            ware_data['price_min'] = price.get('min', '')
            ware_data['price_average'] = price.get('average', '')
            ware_data['price_max'] = price.get('max', '')
        
        # Get owner factions
        owners = ware.findall('owner')
        if owners:
            factions = [owner.get('faction', '') for owner in owners]
            ware_data['owner_factions'] = ';'.join(factions)
        
        # Handle research node
        research = ware.find('research')
        if research is not None:
            ware_data['research_time'] = research.get('time', '')
            primary = research.find('primary')
            if primary is not None:
                resources = []
                for resource in primary.findall('ware'):
                    resource_str = f"{resource.get('ware')}:{resource.get('amount')}"
                    resources.append(resource_str)
                ware_data['research_resources'] = ';'.join(resources)
        
        # Handle multiple production nodes
        productions = ware.findall('production')
        if productions:
            times = []
            amounts = []
            methods = []
            resources_list = []
            for production in productions:
                times.append(production.get('time', ''))
                amounts.append(production.get('amount', ''))
                methods.append(production.get('method', ''))
                primary = production.find('primary')
                if primary is not None:
                    resources = []
                    for resource in primary.findall('ware'):
                        resource_str = f"{resource.get('ware')}:{resource.get('amount')}"
                        resources.append(resource_str)
                    resources_list.append('|'.join(resources))  # Use '|' to separate resource sets
                else:
                    resources_list.append('')
            ware_data['production_times'] = ';'.join(times)
            ware_data['production_amounts'] = ';'.join(amounts)
            ware_data['production_methods'] = ';'.join(methods)
            ware_data['primary_resources_list'] = ';'.join(resources_list)
        
        # Handle icon node
        icon = ware.find('icon')
        if icon is not None:
            ware_data['icon_active'] = icon.get('active', '')
            ware_data['icon_video'] = icon.get('video', '')
        
        # Handle container node
        container = ware.find('container')
        if container is not None:
            ware_data['container_ref'] = container.get('ref', '')
        
        if ware_data['id']:
            writer.writerow([ware_data[key] for key in headers])
    
    # Get the final CSV string and strip any trailing newlines
    csv_content = output.getvalue().rstrip('\n')
    output.close()
    return csv_content

# Load the file
with open(input_file, 'r') as file:
    xml_data = file.read()

# Convert to CSV and print
csv_result = parse_xml_to_csv(xml_data)
print(csv_result)

# Save to file
with open(output_file, 'w', newline='') as f:
    f.write(csv_result)