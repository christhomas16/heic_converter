#!/usr/bin/env python3

import os
import sys
import argparse
from PIL import Image
from pillow_heif import register_heif_opener

def convert_heic_to_jpg(heic_path, quality=90):
    """
    Convert a HEIC file to JPG format.
    
    Args:
        heic_path (str): Path to the HEIC file
        quality (int): JPG quality (1-100)
        
    Returns:
        str: Path to the created JPG file
    """
    # Register the HEIF opener to allow PIL to open HEIC files
    register_heif_opener()
    
    # Check if file exists
    if not os.path.exists(heic_path):
        print(f"Error: File '{heic_path}' not found.")
        return None
    
    # Check if file is a HEIC file
    if not heic_path.lower().endswith(('.heic', '.heif')):
        print(f"Error: File '{heic_path}' is not a HEIC/HEIF file.")
        return None
    
    try:
        # Create output filename (replace extension with .jpg)
        jpg_path = os.path.splitext(heic_path)[0] + '.jpg'
        
        # Open and convert the image
        image = Image.open(heic_path)
        
        # Save as JPG
        image.save(jpg_path, 'JPEG', quality=quality)
        
        print(f"Successfully converted '{heic_path}' to '{jpg_path}'")
        return jpg_path
    
    except Exception as e:
        print(f"Error converting file: {e}")
        return None

def main():
    parser = argparse.ArgumentParser(description='Convert HEIC images to JPG format')
    parser.add_argument('heic_file', help='Path to the HEIC file to convert')
    parser.add_argument('-q', '--quality', type=int, default=90, 
                        help='JPG quality (1-100, default: 90)')
    
    args = parser.parse_args()
    
    convert_heic_to_jpg(args.heic_file, args.quality)

if __name__ == "__main__":
    main() 