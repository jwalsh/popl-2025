# POPL 2025 Quick Start

1. Clone repository:
   ```sh
   git clone https://github.com/jwalsh/popl-2025.git
   cd popl-2025
   ```

2. Check setup:
   ```sh
   ./scripts/check-setup.sh
   ```

3. Initialize environment:
   ```sh
   # With Docker
   make docker-build
   
   # Without Docker
   make init
   ```

4. Start taking notes:
   ```sh
   # Daily notes in notes/
   # Papers in papers/
   # Citations in bib/popl2025.bib
   ```

5. Export content:
   ```sh
   make all-exports
   ```

See README.org for full documentation.
