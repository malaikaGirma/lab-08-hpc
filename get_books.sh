
#!/bin/bash
set -euo pipefail

# Check that exactly two arguments were provided
if [ "$#" -ne 2 ]; then
    echo "Usage: bash get_books.sh BUCKET_NAME BOOK_DIRECTORY"
    exit 1
fi

# Store the arguments
bucket="$1"
book_dir="$2"

# Create the directory if it doesn't exist
mkdir -p "$book_dir"

# Convert the directory to an absolute path
book_dir=$(realpath "$book_dir")

# Copy only .txt files from the S3 bucket
aws s3 cp "s3://$bucket/" "$book_dir/" \
    --recursive \
    --exclude "*" \
    --include "*.txt"

# Create the book list with a header
printf "File path\n" > book_list.txt

# Find all text files, sort them, and append their absolute paths
find "$book_dir" -type f -name "*.txt" | sort >> book_list.txt

# Count the books (excluding the header)
book_count=$(($(wc -l < book_list.txt) - 1))

echo "Wrote $book_count book files to book_list.txt"

