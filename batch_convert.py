#!/usr/bin/env python3

import os
import argparse
import glob
from heic_to_jpg import convert_heic_to_jpg

def batch_convert(directory, pattern="*.heic", quality=90, recursive=False):
    """
    Convert all HEIC files in a directory to JPG format.
    
    Args:
        directory (str): Directory containing HEIC files
        pattern (str): File pattern to match (default: "*.heic")
        quality (int): JPG quality (1-100)
        recursive (bool): Whether to search subdirectories
    """
    if not os.path.isdir(directory):
        print(f"Error: '{directory}' is not a valid directory.")
        return
    
    # Normalize directory path
    directory = os.path.normpath(directory)
    
    # Set up glob pattern
    if recursive:
        search_pattern = os.path.join(directory, "**", pattern)
        files = glob.glob(search_pattern, recursive=True)
    else:
        search_pattern = os.path.join(directory, pattern)
        files = glob.glob(search_pattern)
    
    if not files:
        print(f"No files matching '{pattern}' found in '{directory}'.")
        return
    
    print(f"Found {len(files)} files to convert.")
    
    # Convert each file
    success_count = 0
    for file_path in files:
        result = convert_heic_to_jpg(file_path, quality)
        if result:
            success_count += 1
    
    print(f"Conversion complete. Successfully converted {success_count} of {len(files)} files.")

def main():
    parser = argparse.ArgumentParser(description='Batch convert HEIC images to JPG format')
    parser.add_argument('directory', help='Directory containing HEIC files')
    parser.add_argument('-p', '--pattern', default="*.heic", 
                        help='File pattern to match (default: "*.heic")')
    parser.add_argument('-q', '--quality', type=int, default=90, 
                        help='JPG quality (1-100, default: 90)')
    parser.add_argument('-r', '--recursive', action='store_true',
                        help='Search subdirectories recursively')
    
    args = parser.parse_args()
    
    batch_convert(args.directory, args.pattern, args.quality, args.recursive)

if __name__ == "__main__":
    main() 