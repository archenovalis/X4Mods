import re

# Function to modify lines matching the price pattern
def modify_line(i, lines, line, macroDirectories, priceMult):
    # Regex pattern to match the price line
    if '//ware[@id=' in line:
        idMatch = re.match(r'.*id=\'([a-zA-Z0-9_-]*)\'\s*', line).group(1)
        if idMatch:
            priceMatch = re.match(r'.*"\d+\s*".*"(\d+)\s*".*"\d+\s*".*"(.*)"', lines[i+1])
            return f'{idMatch}\t{priceMatch.group(1)}\t{priceMatch.group(2)}\n'
    if '<ware id=' in line:
        idMatch = re.match(r'<ware id="([a-zA-Z0-9_-]*)\s*"', line).group(1)
        priceMatch = re.match(r'.*"(\d+)\s*".*"(\d+)\s*".*"(\d+)\s*".*', lines[i+1])
        if not int(priceMatch.group(3)) > 1: 
            print('-- ', idMatch)
            print('??? no price')
            return ''
        average_price = int(priceMatch.group(2))
        macro = re.match(r'<component ref="([a-zA-Z0-9_-]*)\s*"', lines[i+2]).group(1)
        hull, docksize = obtain_macro_data(macro, macroDirectories)
        if hull == '' or docksize == '':
            print('-- ', idMatch)
            print(f'hull: {hull}  |  docksize: {docksize}')
            return ''
        try:
            mult = priceMult[docksize]
        except: 
            print('-- ', idMatch)
            print('!!! invalid docksize: ', docksize)
            return ''
        if mult == 0:
            return ''
        #average_price = int(hull) * mult
        
        return f'{idMatch}\t{average_price}\t{hull}\t{docksize}\n'
    return ''

def obtain_macro_data(macro, macroDirectories):
    hull = ''
    docksize = ''
    for macroDirectory in macroDirectories:
        macroFile = macroDirectory + macro + '.xml'
        try:
            with open(macroFile, 'r') as file:
                lines = file.readlines()
                for line in lines:
                    if re.match(r'.*class="([a-zA-Z0-9-_]*)\s*"', line):
                        docksize = re.match(r'.*class="([a-zA-Z0-9-_]*)\s*"', line).group(1)
                    if re.match(r'.*<hull max="(\d*)\s*"', line):
                        hull = re.match(r'.*<hull max="(\d*)\s*"', line).group(1)
                        if docksize != '' and docksize != 'ship_xl':
                            return hull, docksize
                    if re.match(r'.*<docksize tag="([a-zA-Z0-9-_]*)\s*"', line):
                        docksize = re.match(r'.*<docksize tag="([a-zA-Z0-9-_]*)\s*"', line).group(1)
                        return hull, docksize
        except FileNotFoundError:
            continue
    return hull, docksize

# Function to read, modify, and write to the file
def process_file(input_file, output_file, macroDirectories, priceMult):
    with open(input_file, 'r') as file:
        lines = file.readlines()

    modified_lines = []

    i = 0
    for line in lines:
        modified_line = modify_line(i, lines, line, macroDirectories, priceMult)
        if modified_line: modified_lines.append(modified_line)
        i += 1

    with open(output_file, 'w') as file:
        file.writelines(modified_lines)

    print(f"File processed and saved as {output_file}")

# Example usage
input_file = '12-9-12-18_ships.xml'
output_file = 'compared_'+input_file
# S M L XL XXL (0 = no changes)
rate = 1
priceMult = dict(
    ship_s = 1,
    ship_m = rate,
    ship_l = rate,
    ship_xl = rate,
    dock_xl = rate,
    dock_xxl = rate,
    dock_dxxl = rate,
    dock_l_mandator_2 = rate
    )
macroDirectories = [
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extensions\\sov_dreadnaughts\\assets\\units\\size_xl\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extensions\\swi_heroes\\assets\\units\\size_l\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extensions\\swi_heroes\\assets\\units\\size_m\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extensions\\swi_heroes\\assets\\units\\size_s\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extensions\\swi_heroes\\assets\\units\\size_xl\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extensions\\swi_heroes\\assets\\units\\size_xxl\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extensions\\starwarsmod_m1\\assets\\units\\size_l\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extensions\\starwarsmod_m1\\assets\\units\\size_s\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extensions\\starwarsmod_m1\\assets\\units\\size_m\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extensions\\starwarsmod_m1\\assets\\units\\size_xl\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extensions\\starwarsmod_m1\\assets\\units\\size_xxl\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extracted_xsd_xml_all\\assets\\units\\size_l\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extracted_xsd_xml_all\\assets\\units\\size_s\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extracted_xsd_xml_all\\assets\\units\\size_m\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extracted_xsd_xml_all\\assets\\units\\size_xl\\macros\\'
    ]
process_file(input_file, output_file, macroDirectories, priceMult)
