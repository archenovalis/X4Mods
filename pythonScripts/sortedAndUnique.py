import xml.etree.ElementTree as ET

# Parse XML
tree = ET.parse('reduced_wares2.xml')
root = tree.getroot()

# Collect and sort replace elements by ID
replaces = sorted(root.findall('.//replace'), key=lambda x: x.get('sel').split("'")[1])

# Remove duplicates
unique_replaces = []
seen = set()
for replace in replaces:
    id = replace.get('sel').split("'")[1]
    if id not in seen:
        seen.add(id)
        unique_replaces.append(replace)

# Create new root and append unique elements
new_root = ET.Element(root.tag, attrib=root.attrib)
for replace in unique_replaces:
    new_root.append(replace)

# Add indentation and write to file
ET.indent(new_root, space="  ")
with open('sorted_and_unique.xml', 'wb') as f:
    f.write(ET.tostring(new_root, encoding='utf-8'))