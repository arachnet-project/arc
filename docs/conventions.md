# ARC_FILE: docs/conventions.md

# The `ARC_FILE:` convention

Every file managed by the ARC deployment workflow must carry its path
relative to the current project root in an `ARC_FILE:` comment.

## Marker position

For ordinary files, the marker must be the first line:

```text
# ARC_FILE: src/common/db_connection.py
```

Executable scripts whose interpreter is selected by a shebang are the only
exception. Their shebang remains on line 1 and the marker goes on line 2:

```bash
#!/bin/bash
# ARC_FILE: scripts/bootstrap.sh
```

The shebang must remain first because operating systems recognize it only in
that position.

## Format

The comment style depends on the file's language:

| File type | Marker format |
|---|---|
| Python, Bash, YAML, Markdown | `# ARC_FILE: src/common/db_connection.py` |
| SQL | `-- ARC_FILE: sql/ddl/create_schema.sql` |

The path after `ARC_FILE:` must always be relative to `$PROJECT_ROOT` for the
project currently being worked on. It must never be absolute and must not
contain `..` as a path component.

## Why it exists

When a file is staged in `~/.cb/downloads/`, either through `xsd` or by being
placed there manually, its staging location does not identify its intended
location inside the project. The `ARC_FILE:` marker supplies that metadata.
`xdep` reads it to determine the destination below `$PROJECT_ROOT`.

## Enforcement

- **`xdep`** reads the marker from line 1, or from line 2 when line 1 is a
  shebang. It removes the `#` or `--` comment prefix and the `ARC_FILE:` label,
  then deploys the file to the resulting path below `$PROJECT_ROOT`. It refuses
  an absent or malformed marker, an empty path, an absolute path, or a path
  containing a `..` component.
- **`xmd`** validates the marker on line 1 of a Markdown file and removes that
  line before passing the remaining document to Pandoc. The marker is workflow
  metadata and does not appear in the generated HTML, PDF, DOCX, or other
  output.

Both commands stop instead of guessing when validation fails. A stopped
operation is safer than deploying to an unintended location or including the
marker in a rendered document.

## Examples

A Python module destined for `src/common/db_connection.py` starts with:

```python
# ARC_FILE: src/common/db_connection.py

import sqlite3
```

After `xsd db_connection.py` and `xdep db_connection.py`, it is deployed to:

```text
$PROJECT_ROOT/src/common/db_connection.py
```

An executable Bash script destined for `scripts/bootstrap.sh` starts with:

```bash
#!/bin/bash
# ARC_FILE: scripts/bootstrap.sh
```

## Existing projects

Files from projects that predate this convention need the marker before ARC
can deploy or transform them. There is currently no bulk-migration command;
the marker must be added manually to each managed file.
