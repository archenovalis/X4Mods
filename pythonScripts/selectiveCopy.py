import os
import shutil
import sys
import re

def parse_args(args):
    source, destination = None, None
    include = ['*']
    exclude = []
    case_sensitive = False
    
    if len(args) == 1 or any(arg in args[1:] for arg in ['--help', '/', '/?', '-?', '-h']):
        print_help()
        sys.exit(0)
    
    i = 1
    while i < len(args):
        if args[i].startswith('-'):
            if args[i] in ['-i', '--include']:
                i += 1
                include = []
                while i < len(args) and not args[i].startswith('-'):
                    include.append(args[i])
                    i += 1
                i -= 1
            elif args[i] in ['-e', '--exclude']:
                i += 1
                while i < len(args) and not args[i].startswith('-'):
                    exclude.append(args[i])
                    i += 1
                i -= 1
            elif args[i] in ['-x', '--case-sensitive']:
                case_sensitive = True
            else:
                print(f"Unknown argument: {args[i]}\n")
                print_help()
                sys.exit(1)
        else:
            if source is None:
                source = args[i]
            elif destination is None:
                destination = args[i]
            else:
                print("Too many positional arguments\n")
                print_help()
                sys.exit(1)
        i += 1

    if not source or not destination:
        print("Error: Missing source or destination directory.\n")
        print_help()
        sys.exit(1)

    return source, destination, include, exclude, case_sensitive

def match_pattern(filename, pattern, case_sensitive):
    if not case_sensitive:
        filename = filename.lower()
        pattern = pattern.lower()
    
    if pattern == '*' or pattern == '*.*':  # Match all files
        return True
    elif pattern == '*.':  # Match only files without extension
        return '.' not in filename
    else:
        pattern = pattern.replace('.', r'\.')  # Escape dots
        pattern = pattern.replace('*', '.*')    # Convert * to regex .* for any character sequence
        return re.match(pattern, filename) is not None

def copy_files_with_extensions(source_dir, destination_dir, include_extensions, exclude_extensions, case_sensitive):
    copied_count = 0
    copied_by_ext = {}
    skipped_count = 0
    skipped_by_ext = {}
    
    for root, dirs, files in os.walk(source_dir):
        for file in files:
            if any(match_pattern(file, ext, case_sensitive) for ext in include_extensions):
                if not any(match_pattern(file, ext, case_sensitive) for ext in exclude_extensions):
                    relative_path = os.path.relpath(root, source_dir)
                    dest_path = os.path.join(destination_dir, relative_path)
                    os.makedirs(dest_path, exist_ok=True)
                    
                    try:
                        shutil.copy2(os.path.join(root, file), os.path.join(dest_path, file))
                        copied_count += 1
                        file_ext = os.path.splitext(file)[1]
                        if not file_ext: file_ext = "<no ext>"
                        file_ext = file_ext.lower() if not case_sensitive else file_ext
                        copied_by_ext[file_ext] = copied_by_ext.get(file_ext, 0) + 1
                    except Exception as e:
                        print(f"Error copying {os.path.join(root, file)}: {e}")
                else:
                    skipped_count += 1
                    file_ext = os.path.splitext(file)[1]
                    if not file_ext: file_ext = "<no ext>"
                    file_ext = file_ext.lower() if not case_sensitive else file_ext
                    skipped_by_ext[file_ext] = skipped_by_ext.get(file_ext, 0) + 1

    return copied_count, copied_by_ext, skipped_count, skipped_by_ext

def print_help():
    print("File Copy Script with Pattern Matching")
    print("\nUsage:")
    print("  python script.py <source> <destination> [OPTIONS]")
    print("\nOptions:")
    print("  -i, --include PATTERN     Include files matching this pattern (default: *)")
    print("                            Use '*.': for files without extensions only")
    print("                            Use '*' or '*.*' for all files")
    print("  -e, --exclude PATTERN     Exclude files matching this pattern (default: none)")
    print("  -x, --case-sensitive      Make pattern matching case-sensitive")
    print("  -h, --help, /, /?, -?     Show this help message")
    print("\nExamples:")
    print("  python script.py source_dir dest_dir -i *.txt *.md -e *.tmp")
    print("  python script.py source_dir dest_dir -i *.*")
    print("  python script.py source_dir dest_dir -i *. -x")

if __name__ == "__main__":
    try:
        source_dir, dest_dir, include_exts, exclude_exts, case_sensitive = parse_args(sys.argv)
        
        print(f"\nSettings:")
        print(f"  Source directory: {source_dir}")
        print(f"  Destination directory: {dest_dir}")
        print(f"  Including patterns: {include_exts}")
        print(f"  Excluding patterns: {exclude_exts}")
        print(f"  Case sensitive: {case_sensitive}")

        if not os.path.isdir(source_dir):
            print(f"Source directory does not exist: {source_dir}")
            sys.exit(1)

        copied_count, copied_by_ext, skipped_count, skipped_by_ext = copy_files_with_extensions(source_dir, dest_dir, include_exts, exclude_exts, case_sensitive)

        print("\nResults:")
        print(f"\n  Copied: {copied_count}\n")
        for ext in sorted(copied_by_ext.keys()):
            print(f"     {copied_by_ext[ext]:<7} {ext}")
        print(f"\n  Skipped: {skipped_count}\n")
        for ext in sorted(skipped_by_ext.keys()):
            print(f"     {skipped_by_ext[ext]:<7} {ext}")
    except Exception as e:
        print(f"An error occurred: {e}\n")
        print_help()