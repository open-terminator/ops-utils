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

The repository is intentionally small:

- `bin/` contains the executable shell utilities
- `README.md` documents usage and layout
- `LICENSE` keeps redistribution straightforward

## Included tools

### `bin/new-repo-from-template.sh`

Create a new local repository from a template provided by `repo-factory`.

```bash
./bin/new-repo-from-template.sh generic ./demo demo
```

If `repo-factory` is not located next to `ops-utils`, set:

```bash
export REPO_FACTORY_TEMPLATES_DIR=/path/to/repo-factory/templates
```

### `bin/repo-overview.sh`

Show branch, upstream, and working-tree status for all repositories under a given root directory.

```bash
./bin/repo-overview.sh .
```

### `bin/repo-unpushed.sh`

List local commits that exist in child repositories but have not been pushed to their upstream branch yet.

```bash
./bin/repo-unpushed.sh .
```

### `bin/repo-missing-upstream.sh`

List child repositories that do not have an upstream branch configured yet.

```bash
./bin/repo-missing-upstream.sh .
```

### `bin/repo-missing-remote.sh`

List child repositories that do not have a given remote configured.

```bash
./bin/repo-missing-remote.sh .
./bin/repo-missing-remote.sh . origin
```

### `bin/repo-remotes.sh`

List child repositories together with each configured remote and its URL.

```bash
./bin/repo-remotes.sh .
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
├── repo-missing-remote.sh
├── repo-missing-upstream.sh
├── repo-overview.sh
├── repo-remotes.sh
└── repo-unpushed.sh
```

## License

MIT
