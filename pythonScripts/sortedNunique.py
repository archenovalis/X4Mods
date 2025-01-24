import xml.etree.ElementTree as ET
from xml.dom import minidom  # For pretty printing

# Parse XML
tree = ET.parse('reduced_wares2.xml')
root = tree.getroot()

# Collect replace elements
replaces = []
for replace in root.findall('.//replace'):
    id = replace.get('sel').split("'")[1]  # Extract ID from sel attribute
    replaces.append((id, replace))

# Sort by ID
sorted_replaces = sorted(replaces, key=lambda x: x[0])

# Remove duplicates if any (not needed in this case but for generalization)
unique_replaces = []
seen = set()
for id, replace in sorted_replaces:
    if id not in seen:
        seen.add(id)
        unique_replaces.append(replace)

# Create a new root element for your sorted data
new_root = ET.Element(root.tag, attrib=root.attrib)

# Append only the sorted and unique elements to the new root
for replace in unique_replaces:
    new_root.append(replace)

# Wrap the new root in a tree to make it writable
new_tree = ET.ElementTree(new_root)

# Pretty print the XML with adjusted whitespace
rough_string = ET.tostring(new_root, 'utf-8')
reparsed = minidom.parseString(rough_string)
pretty_str = reparsed.toprettyxml(indent="  ")

# Remove excess blank lines
lines = pretty_str.splitlines()
# Filter out lines that are only whitespace
non_empty_lines = [line for line in lines if line.strip()]
# Join back without extra newlines
cleaned_str = "\n".join(non_empty_lines)

# Write back to file
with open('sorted_and_unique.xml', 'w') as f:
    f.write(cleaned_str)