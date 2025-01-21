#!/bin/bash

# Create GitHub Pages workflow
mkdir -p .github/workflows
cat > .github/workflows/pages.yml << 'END_PAGES'
name: GitHub Pages

on:
  push:
    branches: [ main ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: silex/emacs:29.1
    steps:
      - uses: actions/checkout@v3
      
      - name: Install dependencies
        run: |
          apt-get update
          apt-get install -y make git
          
      - name: Generate exports
        run: |
          emacs --batch \
            --eval "(require 'ox-html)" \
            --eval "(require 'org)" \
            --eval "(dolist (f (directory-files-recursively \"./notes\" \"\\.org$\")) \
                     (with-current-buffer (find-file f) \
                       (org-html-export-to-html)))"
                       
      - name: Generate index
        run: |
          echo "# POPL 2025 Notes" > index.md
          echo "## Daily Notes" >> index.md
          for f in notes/*.html; do
            echo "* [$(basename $f .html)](${f})" >> index.md
          done
          
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v1
        with:
          path: '.'

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v2
END_PAGES

# Add site configuration for GitHub Pages
cat > _config.yml << 'END_CONFIG'
title: POPL 2025 Notes
description: Conference notes and materials for POPL 2025
theme: jekyll-theme-minimal

# Site settings
url: "https://jwalsh.github.io"
baseurl: "/popl-2025"
END_CONFIG

# Update README with Pages info
cat >> README.org << 'END_README'

* Published Notes
The conference notes are automatically published to GitHub Pages:

https://jwalsh.github.io/popl-2025/

Updated on every push to main branch.

* Navigation
- Schedule by day in =notes/=
- Paper annotations in =papers/=
- Implementation ideas in =docs/=
END_README

git add .
git commit -m "Add GitHub Pages deployment"
git push origin main

echo "Added GitHub Pages support! Visit https://jwalsh.github.io/popl-2025/ once deployed."
