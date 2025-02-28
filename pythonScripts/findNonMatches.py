import os

def find_unmatched_lines(source_file, search_directory, output_file):
    # Read lines from the source file
    with open(source_file, 'r') as f:
        source_lines = [line.strip() for line in f.readlines() if line.strip()]
    
    # List to store unmatched lines
    unmatched_lines = []
    
    # Get all files in the directory
    for filename in os.listdir(search_directory):
        file_path = os.path.join(search_directory, filename)
        
        # Check if it's a file (not a directory)
        if os.path.isfile(file_path):
            try:
                # Read content of current file
                with open(file_path, 'r') as f:
                    content = f.read()
                
                # Check each source line against file content
                for line in source_lines[:]:  # Copy list to modify original during iteration
                    if line in content:
                        source_lines.remove(line)  # Remove matched line
                        
            except Exception as e:
                print(f"Error reading {filename}: {e}")
    
    # Any remaining lines in source_lines are unmatched
    unmatched_lines = source_lines
    
    # Write unmatched lines to output file
    with open(output_file, 'w') as f:
        for line in unmatched_lines:
            f.write(f"{line}\n")
    
    return unmatched_lines

# Example usage
if __name__ == "__main__":
    source_file = "message.txt"        # File containing lines to search for
    search_directory = "D:\\Games\\Steam\\steamapps\\common\\X4 Foundations\\extension files\\X4Mods\\xsd"   # Directory to search in
    output_file = "unmatched.txt"     # Where to save unmatched lines
    
    # Create directory and sample files if they don't exist
    if not os.path.exists(search_directory):
        os.makedirs(search_directory)
    
    unmatched = find_unmatched_lines(source_file, search_directory, output_file)
    
    print("Unmatched lines:")
    for line in unmatched:
        print(line)
    print(f"Unmatched lines saved to {output_file}")