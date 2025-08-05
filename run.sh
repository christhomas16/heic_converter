#!/bin/bash

# HEIC to JPG Converter - Shell Wrapper Script
# This script manages the Python virtual environment and runs the conversion tool

set -e  # Exit on any error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"
PYTHON_SCRIPT="$SCRIPT_DIR/heic_to_jpg.py"
BATCH_SCRIPT="$SCRIPT_DIR/batch_convert.py"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show help
show_help() {
    cat << EOF
HEIC to JPG Converter - Shell Wrapper

USAGE:
    $0 [OPTIONS] <command> [arguments...]

COMMANDS:
    convert <file>              Convert a single HEIC file to JPG
    batch <directory>           Convert all HEIC files in a directory
    setup                       Set up the Python virtual environment
    help                        Show this help message

OPTIONS:
    -q, --quality <1-100>       Set JPG quality (default: 90)
    -r, --recursive             For batch mode: search subdirectories
    -p, --pattern <pattern>     For batch mode: file pattern (default: "*.heic")
    -h, --help                  Show this help message

EXAMPLES:
    $0 convert photo.heic
    $0 convert photo.heic -q 95
    $0 batch ./photos
    $0 batch ./photos -r -q 85
    $0 batch ./photos -p "*IMG*.heic"
    $0 setup

NOTES:
    - The script automatically sets up the Python virtual environment
    - Converted files are saved in the same directory as the source files
    - The virtual environment is created in: $VENV_DIR

EOF
}

# Function to check if virtual environment exists and create if needed
setup_venv() {
    if [ ! -d "$VENV_DIR" ]; then
        print_info "Creating Python virtual environment..."
        python3 -m venv "$VENV_DIR"
        print_success "Virtual environment created at $VENV_DIR"
    fi

    # Activate virtual environment
    source "$VENV_DIR/bin/activate"

    # Check if dependencies are installed
    if ! python -c "import PIL, pillow_heif" 2>/dev/null; then
        print_info "Installing Python dependencies..."
        pip install -r "$SCRIPT_DIR/requirements.txt"
        print_success "Dependencies installed successfully"
    fi
}

# Function to run single file conversion
run_convert() {
    local file="$1"
    shift
    local args=("$@")
    
    if [ -z "$file" ]; then
        print_error "No file specified for conversion"
        echo "Usage: $0 convert <file> [options]"
        exit 1
    fi
    
    if [ ! -f "$file" ]; then
        print_error "File not found: $file"
        exit 1
    fi
    
    print_info "Converting: $file"
    python "$PYTHON_SCRIPT" "$file" "${args[@]}"
}

# Function to run batch conversion
run_batch() {
    local directory="$1"
    shift
    local args=("$@")
    
    if [ -z "$directory" ]; then
        print_error "No directory specified for batch conversion"
        echo "Usage: $0 batch <directory> [options]"
        exit 1
    fi
    
    if [ ! -d "$directory" ]; then
        print_error "Directory not found: $directory"
        exit 1
    fi
    
    print_info "Batch converting files in: $directory"
    python "$BATCH_SCRIPT" "$directory" "${args[@]}"
}

# Main script logic
main() {
    # Handle help flags
    case "$1" in
        -h|--help|help|"")
            show_help
            exit 0
            ;;
    esac

    # Set up virtual environment
    setup_venv

    local command="$1"
    shift

    case "$command" in
        convert)
            run_convert "$@"
            ;;
        batch)
            run_batch "$@"
            ;;
        setup)
            print_success "Environment setup complete"
            ;;
        *)
            print_error "Unknown command: $command"
            echo "Run '$0 --help' for usage information"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"