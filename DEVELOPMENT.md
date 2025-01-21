# Development Guide

This repository shows how to set up a conference note-taking environment, particularly for POPL 2025. The structure and tools can be used as a template for other conferences.

## Architecture

### Input Sources
1. Conference Schedule (ICS)
2. Session Information (HTML/JSON)
3. Personal Preferences (User Manual)

### Key Components
- Org-mode for structured notes
- Docker for reproducible environment
- GitHub Actions for publishing
- Python tools for automation

## Local Development

### Prerequisites
```sh
# Python dependencies
poetry install

# Environment setup
cp .envrc.sample .envrc.local
direnv allow
```

### Testing Changes
```sh
# Validate environment
make validate

# Test exports
make all-exports
```

## Adding Features

### New Templates
Add templates to `scripts/templates/`:
1. Create template file
2. Update template loading in helpers
3. Document usage

### New Scripts
Add scripts to `scripts/`:
1. Create script
2. Make executable
3. Add to Makefile if needed
4. Document usage

## Release Process
1. Update version in pyproject.toml
2. Update CHANGELOG.md
3. Create GitHub release
4. Push Docker image

## Best Practices
- Use org-mode properties for metadata
- Keep templates generic
- Document extensively
- Test with different conferences

## Conference Setup Checklist
1. Clone template
2. Update configuration
3. Import schedule
4. Setup automation
5. Test environment

## Contributing
See CONTRIBUTING.md for guidelines.
