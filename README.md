<div align="center">

# ops-utils

Small practical shell utilities for repository setup and maintenance.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Shell](https://img.shields.io/badge/language-shell-89e051)
![Status](https://img.shields.io/badge/status-active-2ea44f)
![Focus](https://img.shields.io/badge/focus-practical_tools-black)

</div>

## Overview

`ops-utils` collects small command-line tools for recurring repository and workspace tasks.

The goal is simple: ship utilities that are genuinely useful in day-to-day work, keep them readable, and avoid bloated scaffolding.

## Included tools

### `bin/new-repo-from-template.sh`

Create a new local repository from a template provided by `repo-factory`.

```bash
./bin/new-repo-from-template.sh generic /home/luca/projects/openclaw/demo demo
```

### `bin/repo-overview.sh`

Show branch, upstream, and working-tree status for all repositories under a given root directory.

```bash
./bin/repo-overview.sh /home/luca/projects/openclaw
```

## Design principles

- build small, useful tools first
- keep dependencies low
- prefer clarity over cleverness
- avoid storing secrets in repositories

## Repository layout

```text
bin/
├── new-repo-from-template.sh
└── repo-overview.sh
```

## License

MIT
