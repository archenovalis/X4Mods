file_path = 'wares-combined.xml'
output_file = 'parsed_ships.xml'

with open(file_path, 'r') as file:
    lines = file.readlines()

filtered_lines = []

for i in range(len(lines)):
    line = lines[i]
    if '<ware id' in line and 'transport="ship"' in line:
        j = i + 1
        while '</ware>' not in lines[j]:
            if '<price' in lines[j]:
                if 'max="1"' in lines[j]:
                    break
                filtered_lines.append(line)
                filtered_lines.append(lines[j])
            if '<component ref' in lines[j]:
                filtered_lines.append(lines[j])
                break
            j += 1


with open(output_file, 'w') as output:
    for line in filtered_lines:
        output.write(line)

print(f"Filtered content has been saved to {output_file}")
