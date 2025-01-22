#!/bin/bash

# Configuration
PAPERS_DIR="$(git rev-parse --show-toplevel)/papers"
ARXIV_DIR="${PAPERS_DIR}/arxiv"
SLIDES_DIR="${PAPERS_DIR}/slides"
SUPPL_DIR="${PAPERS_DIR}/supplementary"

# Create directories if they don't exist
mkdir -p "${ARXIV_DIR}" "${SLIDES_DIR}" "${SUPPL_DIR}"

# Function to extract arxiv ID from URL
get_arxiv_id() {
    local url=$1
    if [[ $url =~ arxiv\.org/[^/]*/([0-9]+\.[0-9]+) ]]; then
        echo "${BASH_REMATCH[1]}"
    fi
}

# Function to download paper
download_paper() {
    local url=$1
    local target_dir=$2
    local filename=$3

    echo "Downloading $url to $target_dir/$filename"
    curl -L "$url" -o "$target_dir/$filename"
    
    if [ $? -eq 0 ]; then
        echo "Successfully downloaded to $target_dir/$filename"
        # Create a simple metadata file
        echo "URL: $url" > "$target_dir/${filename%.pdf}.meta"
        echo "Downloaded: $(date --iso-8601=seconds)" >> "$target_dir/${filename%.pdf}.meta"
    else
        echo "Failed to download $url"
        return 1
    fi
}

# Main logic
main() {
    local url=$1
    
    if [[ -z "$url" ]]; then
        echo "Usage: $0 <paper-url>"
        echo "Example: $0 https://arxiv.org/pdf/2411.07078"
        exit 1
    fi

    # Handle arXiv URLs
    if [[ $url == *arxiv.org* ]]; then
        local arxiv_id=$(get_arxiv_id "$url")
        if [[ -n "$arxiv_id" ]]; then
            download_paper "$url" "$ARXIV_DIR" "${arxiv_id}.pdf"
        else
            echo "Could not extract arXiv ID from URL"
            exit 1
        fi
    else
        # For other URLs, use the last part of the path as filename
        local filename=$(basename "$url")
        if [[ ! $filename =~ \.pdf$ ]]; then
            filename="${filename}.pdf"
        fi
        download_paper "$url" "$PAPERS_DIR" "$filename"
    fi
}

main "$@"
