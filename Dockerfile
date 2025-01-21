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
