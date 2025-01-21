#!/bin/bash

# Create Dockerfile for consistent environment
cat > Dockerfile << 'END_DOCKERFILE'
FROM silex/emacs:29.1

# Install git and other essentials
RUN apt-get update && apt-get install -y \
    git \
    make \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set up workspace
WORKDIR /workspace
COPY . /workspace

# Install org-mode extras
RUN emacs --batch --eval "(progn \
    (require 'package) \
    (add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\") t) \
    (package-initialize) \
    (package-refresh-contents) \
    (package-install 'ox-pandoc) \
    (package-install 'org-ref))"

# Set up entrypoint for exports
COPY scripts/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["make", "all-exports"]
END_DOCKERFILE

# Create docker entrypoint script
mkdir -p scripts
cat > scripts/docker-entrypoint.sh << 'END_ENTRYPOINT'
#!/bin/bash
set -e

# Initialize git config
git config --global user.email "docker@popl2025.local"
git config --global user.name "POPL Docker"

exec "$@"
END_ENTRYPOINT

# Add docker compose file for easy usage
cat > docker-compose.yml << 'END_COMPOSE'
version: '3.8'
services:
  notes:
    build: .
    volumes:
      - .:/workspace
    command: make all-exports
END_COMPOSE

# Update Makefile with Docker targets
cat >> Makefile << 'END_MAKE'

# Docker targets
.PHONY: docker-build docker-export docker-shell

docker-build:
	docker-compose build

docker-export:
	docker-compose run --rm notes

docker-shell:
	docker-compose run --rm notes /bin/bash
END_MAKE

# Update README with Docker instructions
cat >> README.org << 'END_README'

* Docker Support
** Quick Start
#+begin_src sh
# Build image
make docker-build

# Generate exports
make docker-export

# Interactive shell
make docker-shell
#+end_src

** Custom Export Commands
Run any make target in Docker:
#+begin_src sh
docker-compose run --rm notes make html
#+end_src

* Environment Setup
This repository includes Docker support for consistent environments:

- Emacs 29.1
- Org-mode with extras
- Export tools pre-configured

Use the provided Docker environment for reliable exports and consistent note-taking.
END_README

git add .
git commit -m "Add Docker support for reproducible environment"
git push origin main

echo "Added Docker support for reproducible exports!"
