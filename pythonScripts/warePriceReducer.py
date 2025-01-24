import re

# Function to modify lines matching the price pattern
def modify_line(line, prev_line, reduce_average_by, reduce_spread_by):
    # Regex pattern to match the price line
    pattern = r'(\s*<price min=")(\d+)(" average=")(\d+)(" max=")(\d+)(" />)'

    # Check if the line matches the pattern
    if re.match(pattern, line):
        # Replace the line with modified values
        return re.sub(pattern, lambda m: reduce_price_spread(m, reduce_average_by, reduce_spread_by, prev_line), line)
    return ''

def reduce_price_spread(match, reduce_average_by, reduce_spread_by, prev_line):
    min_value = int(match.group(2))
    # Modify the price spread only if the min_value is not equal to 1
    if min_value != 1:
        min_value /= reduce_average_by
        average_value = int(match.group(4)) // reduce_average_by
        max_value = int(match.group(6)) // reduce_average_by

        reduced_min_diff = (min_value - average_value) // reduce_spread_by
        reduced_max_diff = (max_value - average_value) // reduce_spread_by

        # Rebuild the string with modified values
        new_min_value = average_value + reduced_min_diff
        new_max_value = average_value + reduced_max_diff

        prev_match = re.match(r'.*id="([a-zA-Z0-9_-]*)"', prev_line)
        new_prev_line = f'<replace sel="//ware[@id=\'{prev_match.group(1)}\']/price">'
        return f'  {new_prev_line}\n    {match.group(1)}{new_min_value}{match.group(3)}{average_value}{match.group(5)}{new_max_value}{match.group(7)}\n  </replace>'
    return ''


# Function to read, modify, and write to the file
def process_file(input_file, output_file, reduce_average_by, reduce_spread_by):
    with open(input_file, 'r') as file:
        lines = file.readlines()

    modified_lines = []
    prev_line = ""

    for line in lines:
        modified_line = modify_line(line, prev_line, reduce_average_by, reduce_spread_by)
        modified_lines.append(modified_line)
        prev_line = line

    with open(output_file, 'w') as file:
        modified_lines.insert(0, '<diff>\n')
        modified_lines.append('</diff>')
        file.writelines(modified_lines)

    print(f"File processed and saved as {output_file}")

# Example usage
input_file = 'parsed_heroes_ships.xml'
output_file = 'reduced_heroes_ships.xml'
reduce_average_by = 1
reduce_spread_by = 2
process_file(input_file, output_file, reduce_average_by, reduce_spread_by)
