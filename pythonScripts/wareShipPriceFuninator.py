import re

# Function to modify lines matching the price pattern
def modify_line(i, lines, line, macroDirectories, priceMult, reduce_spread_by):
    # Regex pattern to match the price line
    if '<ware id=' in line:
      idMatch = re.match(r'\s*<ware id="([a-zA-Z0-9_-]*)\s*"', line).group(1)
      priceMatch = re.match(r'.*"(\d+)\s*".*"(\d+)\s*".*"(\d+)\s*".*', lines[i+1])
      if not int(priceMatch.group(3)) > 1: 
        print('-- ', idMatch)
        print('??? no price')
        return ''
      average_price = int(priceMatch.group(2))
      min_ratio = (1 - (int(priceMatch.group(1)) / average_price))
      if min_ratio < 0:
        print('-- ', idMatch)
        print('!!! invalid min_ratio: ', min_ratio)
        return ''
      else: min_ratio /= reduce_spread_by
      max_ratio = ((int(priceMatch.group(3)) / average_price) - 1)
      if max_ratio < 0:
        print('-- ', idMatch)
        print('!!! invalid max_ratio: ', max_ratio)
        return ''
      else: max_ratio /= reduce_spread_by

      macro = re.match(r'\s*<component ref="([a-zA-Z0-9_-]*)\s*"', lines[i+2]).group(1)
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
      average_price = int(average_price * mult)
      min_price = int(average_price * (1 - min_ratio))
      max_price = int(average_price * (1 + max_ratio))
      
      return f'\n  <replace sel="//ware[@id=\'{idMatch}\']/price">\n    <price min="{min_price}" average="{average_price}" max="{max_price}" /> <!-- {docksize} -->\n  </replace>'
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
                    if re.match(r'\s*<hull max="(\d*)\s*"', line):
                        hull = re.match(r'\s*<hull max="(\d*)\s*"', line).group(1)
                        if docksize != '' and docksize != 'ship_xl':
                            return hull, docksize
                    if re.match(r'\s*<docksize tag="([a-zA-Z0-9-_]*)\s*"', line):
                        docksize = re.match(r'\s*<docksize tag="([a-zA-Z0-9-_]*)\s*"', line).group(1)
                        return hull, docksize
        except FileNotFoundError:
            continue
    return hull, docksize

# Function to read, modify, and write to the file
def process_file(input_file, output_file, macroDirectories, priceMult, reduce_spread_by):
    with open(input_file, 'r') as file:
        lines = file.readlines()

    modified_lines = []

    i = 0
    for line in lines:
        modified_line = modify_line(i, lines, line, macroDirectories, priceMult, reduce_spread_by)
        if modified_line: modified_lines.append(modified_line)
        i += 1

    with open(output_file, 'w') as file:
        modified_lines.insert(0, '<diff>\n')
        modified_lines.append('\n</diff>')
        file.writelines(modified_lines)

    print(f"File processed and saved as {output_file}")

# Example usage
input_file = 'parsed_ships-fixed.xml'

# (0 = no changes)
##### Default ######
#    ship_s = no change,
#    ship_m = 3.536x, 1m = 12 small
#    ship_l = 5.24x, 1l = 9 medium
#    ship_xl = 7.0497x, 1xl = 12 large
#    dock_xxl = 1.465x, 1xxl = 18 extralarge

#output_file = 'wares_ships_12m-9l-12xl-18xxl.xml'

#priceMult = dict(
#    ship_s = 0,
#    ship_m = 3.536,
#    ship_l = 5.24,
#    ship_xl = 7.0497,
#    dock_xl = 7.0497,
#    dock_xxl = 1.465,
#    dock_dxxl = 1.465,
#    dock_l_mandator_2 = 1.465
#    )

output_file = 'wares_ships_spread-only.xml'

rate = 1
priceMult = dict(
    ship_s = 0,
    ship_m = rate,
    ship_l = rate,
    ship_xl = rate,
    dock_xl = rate,
    dock_xxl = rate,
    dock_dxxl = rate,
    dock_l_mandator_2 = rate
    )
reduce_spread_by = 8
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
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extracted_xsd_xml_all\\assets\\units\\size_xl\\macros\\',
    'D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extensions\\Dreadnoughts_additional_package\\assets\\units\\size_xl\\macros\\'
    ]
process_file(input_file, output_file, macroDirectories, priceMult, reduce_spread_by)
