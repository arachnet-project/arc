# ARC_FILE: docs/howto.md

# ARC command how-to

## 1. Load ARC

Select the project that ARC should manage, then source the functions:

```bash
export PROJECT_ROOT="$HOME/project_embeddings"
source "$HOME/arc/aliases.sh"
```

Check that ARC loaded:

```bash
type xi
type xcom
type xdep
```

When changing projects, update `PROJECT_ROOT`:

```bash
export PROJECT_ROOT="$HOME/another_project"
```

## 2. Clipboard buffer

CB is the file `~/.cb/cb`.

| Command | Action |
|---|---|
| `xi` | Copy CB into the system clipboard |
| `xo` | Replace CB with the system clipboard |
| `xoa` | Append the system clipboard to CB |
| `xoe` | Replace CB from the clipboard, then edit CB in Vim |
| `xoae` | Append the clipboard to CB, then edit CB in Vim |
| `xed` | Edit CB in Vim |
| `xcat` | Read CB in the terminal |
| `xclear` | Empty CB |

Examples:

```bash
xcat
xi
xclear
```

## 3. Copy a file into CB

Replace CB with a file's contents:

```bash
xcf README.md
```

Append a file to CB:

```bash
xcfa notes.md
```

## 4. Run a command and capture its output

Output is displayed in the terminal and copied to CB.

Run a Bash script:

```bash
xbash scripts/bootstrap.sh
```

Run a Python script:

```bash
xpy tests/test_connection.py
```

Run any command with arguments:

```bash
xrun git status --short
xrun ls -la
```

The append variants are `xbasha`, `xpya`, and `xruna`.

Check the captured command's result immediately afterward:

```bash
echo $?
```

Zero means success; a nonzero value means failure.

## 5. Commit and push

Commit every change in the current repository:

```bash
xcom "Describe the change"
```

Commit selected paths:

```bash
xcom "Update documentation" README.md docs/conventions.md
```

`xcom` stages, commits, pushes the current branch, displays Git status, and
stores its output in CB. `xcoma` appends that output instead of replacing CB.

When selected paths are supplied, ARC refuses to continue if other changes
were already staged.

## 6. Pull the current branch

The working tree must be clean:

```bash
xpull
```

ARC pulls the matching branch from `origin` using fast-forward-only mode. It
stops rather than creating an automatic merge when histories have diverged.

Use `xpulla` to append the pull output to CB.

## 7. Transfer files through OCI staging

Upload a local file to OCI staging:

```bash
xsup filename.py
```

Download a named file from OCI staging:

```bash
xsd filename.py
```

List locally downloaded files:

```bash
xls
```

Downloaded files are placed in `~/.cb/downloads/`.

## 8. Deploy a staged file

The staged file must contain a valid `ARC_FILE:` marker. For example:

```python
# ARC_FILE: src/common/db_connection.py
```

Deploy it below the current `PROJECT_ROOT`:

```bash
xdep db_connection.py
```

The example is moved to:

```text
$PROJECT_ROOT/src/common/db_connection.py
```

Warning: an existing destination file is replaced without confirmation.

## 9. Extract a package

Supported formats are ZIP, TAR.GZ, and TGZ:

```bash
xupkg package.zip
xupkg package.tar.gz
```

Files are extracted into `~/.cb/downloads/`. Use only trusted archives.

## 10. Transform Markdown

The Markdown file must begin with its marker:

```markdown
# ARC_FILE: docs/report.md
```

Generate HTML, the default:

```bash
xmd docs/report.md
```

Select another Pandoc output format:

```bash
xmd docs/report.md docx
xmd docs/report.md pdf
xmd docs/report.md plain
```

Generated files are written to `~/.cb/transformed_files/`. The metadata line
is removed from the generated document.

## 11. Common errors

### `PROJECT_ROOT is not set`

Set it before sourcing ARC:

```bash
export PROJECT_ROOT="$HOME/project_name"
source "$HOME/arc/aliases.sh"
```

### Linux clipboard command fails

Verify that `xclip` is installed and that the session has access to a graphical
clipboard.

### `xpull` says the working tree is not clean

Commit or stash the changes, then run `xpull` again.

### `xdep` rejects the marker

Check that the path is relative, nonempty, and contains no `..` path component.
For executable scripts, keep the shebang on line 1 and put `ARC_FILE:` on line
2.
