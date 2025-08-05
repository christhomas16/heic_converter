# HEIC to JPG Converter

A simple command-line tool to convert HEIC/HEIF images to JPG format.

## Requirements

- Python 3.6 or higher
- Dependencies listed in `requirements.txt`

## Installation

1. Clone this repository or download the files

2. It is highly recommended to use a Python virtual environment to avoid conflicts with system packages.

   ```bash
   # Create a virtual environment
   python3 -m venv .venv
   
   # Activate the virtual environment
   source .venv/bin/activate
   ```
   *Note: On Windows, activation is `.venv\\Scripts\\activate`*

3. Install the required dependencies:

   ```bash
   # Make sure your virtual environment is active
   pip install -r requirements.txt
   ```

4. Make the scripts executable (on Unix-like systems):

   ```bash
   chmod +x heic_to_jpg.py batch_convert.py
   ```

## Usage

### Option 1: Using the Shell Wrapper (Recommended)

The `run.sh` script automatically manages the virtual environment and provides a convenient interface:

```bash
# Show help
./run.sh --help

# Convert a single file
./run.sh convert photo.heic

# Convert with custom quality
./run.sh convert photo.heic -q 95

# Batch convert all HEIC files in a directory
./run.sh batch ./photos

# Batch convert with options
./run.sh batch ./photos -r -q 85 -p "*IMG*.heic"

# Set up environment only
./run.sh setup
```

### Option 2: Direct Python Execution

**Important:** Make sure your virtual environment is activated before running the scripts.

```bash
source .venv/bin/activate
```

#### Single File Conversion

Convert a single HEIC file to JPG:

```bash
./heic_to_jpg.py path/to/image.heic
```

Specify JPG quality (1-100, default is 90):

```bash
./heic_to_jpg.py path/to/image.heic -q 95
```

Or use Python directly:

```bash
# Make sure your virtual environment is active
python heic_to_jpg.py path/to/image.heic
```

#### Batch Conversion

The `batch_convert.py` script allows you to convert multiple files at once:

```bash
./batch_convert.py path/to/directory
```

Options:
- `-p, --pattern`: File pattern to match (default: "*.heic")
- `-q, --quality`: JPG quality (1-100, default: 90)
- `-r, --recursive`: Search subdirectories recursively

Examples:

```bash
# Convert all HEIC files in the current directory
./batch_convert.py .

# Convert all HEIC files with 95% quality
./batch_convert.py . -q 95

# Convert all HEIC files in a directory and its subdirectories
./batch_convert.py path/to/photos -r

# Convert files with a specific pattern
./batch_convert.py . -p "*IMG*.heic"
```

## Shell-based Batch Processing

You can also use shell commands for batch processing:

### Bash/Zsh:
```bash
for file in *.heic; do ./heic_to_jpg.py "$file"; done
```

### Windows Command Prompt:
```cmd
for %f in (*.heic) do python heic_to_jpg.py "%f"
```

### Windows PowerShell:
```powershell
Get-ChildItem -Filter *.heic | ForEach-Object { python heic_to_jpg.py $_.FullName }
```

## Example

```bash
./heic_to_jpg.py photo.heic
```

This will create a new file called `photo.jpg` in the same directory.

When you are done, you can deactivate the virtual environment:
```bash
deactivate
``` 