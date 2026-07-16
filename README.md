# ARC_FILE: README.md

# arc

Personal Bash workflow tools for clipboard management, file deployment, OCI
transfer, Git operations, and Markdown transformation across multiple machines.

## What it is

ARC is a standalone Git repository containing one sourced Bash file,
`aliases.sh`, and two helper scripts under `wrk/`. It is not tied to a single
project. Before sourcing it, set `PROJECT_ROOT` to the root of the project being
managed.

ARC provides:

- **Clipboard bridging** between `~/.cb/cb` and the macOS or Linux clipboard.
- **File-to-buffer commands** that overwrite or append file contents.
- **Run-and-capture commands** that send output to both the terminal and CB
  while preserving the executed command's exit status.
- **OCI transfer** through an SCP staging directory.
- **Deployment** based on the `ARC_FILE:` path marker.
- **Package extraction** into the local staging directory.
- **Markdown transformation** through Pandoc.
- **Git helpers** for parameterized commits and safe, branch-aware pulls.

## Machines

| Machine | Role | OS | Notes |
|---|---|---|---|
| Ubuntu MacBook Air | Primary repository after migration | Ubuntu | Orca and Voxin/Ava |
| MacBook Pro M1 | Secondary and current reconstruction machine | macOS | Bash terminal and Samantha |
| `arachnetwebserver` (`ara`) | Deployment target | Oracle Linux | OCI user `opc`; not an editing environment |

After the initial repository has been verified, Ubuntu is intended to be the
canonical working clone. Other clones should normally be updated before work
and pushed promptly afterward.

## Repository layout

```text
arc/
  aliases.sh
  README.md
  docs/
    conventions.md
  wrk/
    commit.sh
    pull.sh
```

Runtime data lives outside the repository and must not be committed:

```text
~/.cb/cb
~/.cb/downloads/
~/.cb/transformed_files/
```

## Requirements

ARC is intended for Bash 3.2 or newer. It is not designed to be sourced by
zsh.

Common requirements are:

- `bash`, `git`, `ssh`, `scp`, `tar`, and `tee`;
- `pbcopy` and `pbpaste` on macOS;
- `xclip` and a graphical clipboard session on Linux;
- `unzip` for ZIP packages;
- `pandoc` for `xmd`;
- an appropriate PDF engine when using Pandoc to generate PDF files.

On macOS with Homebrew:

```bash
brew install pandoc
brew install --cask basictex   # only when PDF output is needed
```

On Ubuntu:

```bash
sudo apt install xclip unzip pandoc
```

## Setup

Clone the repository at the location expected by `ARC_ROOT`:

```bash
git clone git@github.com:arachnet-project/arc.git "$HOME/arc"
```

ARC creates its local runtime paths when a command first needs them. They can
also be created explicitly:

```bash
mkdir -p "$HOME/.cb/downloads" "$HOME/.cb/transformed_files"
touch "$HOME/.cb/cb"
```

Prepare the OCI staging directory from a machine with the `ara` SSH alias:

```bash
ssh ara 'mkdir -p ~/.cb/downloads ~/.cb/transformed_files && touch ~/.cb/cb'
```

Set the project root and source ARC from a Bash startup or project-environment
file:

```bash
export PROJECT_ROOT="$HOME/project_embeddings"

if [[ -f "$HOME/arc/aliases.sh" ]]; then
    source "$HOME/arc/aliases.sh"
else
    echo "arc: aliases.sh not found at $HOME/arc/aliases.sh"
fi
```

Use `~/.bashrc` for interactive Bash on Ubuntu. On macOS, use the startup file
appropriate to the way Bash is launched, commonly `~/.bash_profile` for a
login shell. Do not source `aliases.sh` directly from `.zshrc`.

When changing projects, update `PROJECT_ROOT` to the new project's absolute
root before using `xdep`.

## Main commands

### Clipboard and CB

| Command | Purpose |
|---|---|
| `xi` | Copy CB to the system clipboard |
| `xo`, `xoa` | Copy the system clipboard to CB, overwriting or appending |
| `xoe`, `xoae` | Copy to CB and open CB in Vim |
| `xed` | Edit CB in Vim |
| `xcat` | Print CB |
| `xclear` | Empty CB |
| `xcf FILE`, `xcfa FILE` | Copy a file into CB, overwriting or appending |

### Run and capture

| Command | Purpose |
|---|---|
| `xbash FILE`, `xbasha FILE` | Run a Bash script and capture its output |
| `xpy FILE`, `xpya FILE` | Run a Python script and capture its output |
| `xrun COMMAND...`, `xruna COMMAND...` | Run any command and capture its output |

The commands ending in `a` append to CB. The other variants overwrite CB.

### Git

Create a commit containing all repository changes:

```bash
xcom "Describe the change"
```

Commit selected paths:

```bash
xcom "Update documentation" README.md docs/conventions.md
```

When selected paths are supplied, `commit.sh` refuses to proceed if unrelated
changes are already staged. The helper commits, pushes the current branch, and
sets its upstream on the first push.

Update the current branch:

```bash
xpull
```

`xpull` requires a clean working tree and uses a fast-forward-only pull from
the matching branch on `origin`. It refuses detached HEAD and divergent
history instead of creating an automatic merge commit.

Use `xcoma` and `xpulla` when their output should be appended to CB.

### Transfer and deployment

```bash
xsup FILE       # upload a local file to OCI staging
xsd FILE        # download a named file from OCI staging
xls             # list local staged downloads
xdep FILE       # deploy a staged file below PROJECT_ROOT
xupkg ARCHIVE   # extract a supported archive into local staging
```

`xdep` obtains the destination from the file's `ARC_FILE:` marker. See
[`docs/conventions.md`](docs/conventions.md) for the complete convention.

### Markdown

```bash
xmd document.md
xmd document.md html
xmd document.md docx
xmd document.md pdf
```

Markdown files must put their `ARC_FILE:` marker on line 1. ARC removes that
line before passing the document to Pandoc.

## Current limitations

- `xdep` replaces an existing destination file without asking for confirmation.
- Archive extraction assumes that the archive comes from a trusted source.
- Linux clipboard commands require `xclip` and access to a graphical clipboard
  session; they will not normally work on a headless SSH session.
- The corrected workflow still requires end-to-end testing on macOS and Ubuntu.
