# ARC_FILE: aliases.sh
# =============================================================================
# arc — personal workflow toolset
# aliases.sh
# =============================================================================
# Source after exporting PROJECT_ROOT. Intended for Bash 3.2 or newer.

if [[ -z "${PROJECT_ROOT:-}" ]]; then
    echo "arc: PROJECT_ROOT is not set. Export it before sourcing aliases.sh."
    return 1
fi

ARC_ROOT="$HOME/arc"
CB="$HOME/.cb/cb"
CB_DOWNLOADS="$HOME/.cb/downloads"
CB_TRANSFORMED="$HOME/.cb/transformed_files"
OCI_HOST="ara"
OCI_DOWNLOADS="/home/opc/.cb/downloads"

if [[ "$(uname)" == "Darwin" ]]; then
    _CB_COPY=(pbcopy)
    _CB_PASTE=(pbpaste)
else
    _CB_COPY=(xclip -sel clip -i)
    _CB_PASTE=(xclip -sel clip -o)
fi

_arc_runtime_setup() {
    mkdir -p "$CB_DOWNLOADS" "$CB_TRANSFORMED" || return 1
    touch "$CB" || return 1
}

_arc_require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "arc: required command not found: $1"
        return 1
    fi
}

_arc_capture() {
    local mode="$1"
    shift

    _arc_runtime_setup || return 1

    if [[ "$mode" == "append" ]]; then
        "$@" 2>&1 | tee -a "$CB"
    else
        "$@" 2>&1 | tee "$CB"
    fi

    local command_status="${PIPESTATUS[0]}"
    return "$command_status"
}

_arc_clipboard_ready() {
    _arc_runtime_setup || return 1
    _arc_require_command "${_CB_COPY[0]}" || return 1
    _arc_require_command "${_CB_PASTE[0]}" || return 1
}

xi() {
    _arc_clipboard_ready || return 1
    "${_CB_COPY[@]}" < "$CB"
}

xo() {
    _arc_clipboard_ready || return 1
    "${_CB_PASTE[@]}" > "$CB"
}

xoa() {
    _arc_clipboard_ready || return 1
    "${_CB_PASTE[@]}" >> "$CB"
}

xoe() {
    xo && vim "$CB"
}

xoae() {
    xoa && vim "$CB"
}

xed() {
    _arc_runtime_setup || return 1
    vim "$CB"
}

xcat() {
    _arc_runtime_setup || return 1
    cat "$CB"
}

xclear() {
    _arc_runtime_setup || return 1
    > "$CB"
}

xcf() {
    if [[ $# -ne 1 || ! -f "$1" ]]; then
        echo "xcf: usage: xcf filename"
        return 1
    fi
    _arc_runtime_setup || return 1
    cat -- "$1" > "$CB"
}

xcfa() {
    if [[ $# -ne 1 || ! -f "$1" ]]; then
        echo "xcfa: usage: xcfa filename"
        return 1
    fi
    _arc_runtime_setup || return 1
    cat -- "$1" >> "$CB"
}

xcom() {
    _arc_capture overwrite bash "$ARC_ROOT/wrk/commit.sh" "$@"
}

xcoma() {
    _arc_capture append bash "$ARC_ROOT/wrk/commit.sh" "$@"
}

xpull() {
    _arc_capture overwrite bash "$ARC_ROOT/wrk/pull.sh"
}

xpulla() {
    _arc_capture append bash "$ARC_ROOT/wrk/pull.sh"
}

xbash() {
    if [[ $# -ne 1 || ! -f "$1" ]]; then
        echo "xbash: usage: xbash script.sh"
        return 1
    fi
    _arc_capture overwrite bash "$1"
}

xbasha() {
    if [[ $# -ne 1 || ! -f "$1" ]]; then
        echo "xbasha: usage: xbasha script.sh"
        return 1
    fi
    _arc_capture append bash "$1"
}

xpy() {
    if [[ $# -ne 1 || ! -f "$1" ]]; then
        echo "xpy: usage: xpy script.py"
        return 1
    fi
    _arc_capture overwrite python3 "$1"
}

xpya() {
    if [[ $# -ne 1 || ! -f "$1" ]]; then
        echo "xpya: usage: xpya script.py"
        return 1
    fi
    _arc_capture append python3 "$1"
}

xrun() {
    if [[ $# -eq 0 ]]; then
        echo "xrun: usage: xrun command [arguments ...]"
        return 1
    fi
    _arc_capture overwrite "$@"
}

xruna() {
    if [[ $# -eq 0 ]]; then
        echo "xruna: usage: xruna command [arguments ...]"
        return 1
    fi
    _arc_capture append "$@"
}

xsup() {
    if [[ $# -ne 1 || ! -f "$1" ]]; then
        echo "xsup: usage: xsup filename"
        return 1
    fi
    scp -- "$1" "$OCI_HOST:$OCI_DOWNLOADS/"
}

xsd() {
    if [[ $# -ne 1 || -z "$1" || "$1" == */* ]]; then
        echo "xsd: usage: xsd filename"
        return 1
    fi
    _arc_runtime_setup || return 1
    scp "$OCI_HOST:$OCI_DOWNLOADS/$1" "$CB_DOWNLOADS/"
}

xls() {
    _arc_runtime_setup || return 1
    ls -lh "$CB_DOWNLOADS"
}

_arc_marker_path() {
    local input="$1"
    local first_line second_line marker stripped rel_path

    first_line=$(sed -n '1p' "$input") || return 1
    first_line=${first_line%$'\r'}

    if [[ "$first_line" == '#!'* ]]; then
        second_line=$(sed -n '2p' "$input") || return 1
        marker=${second_line%$'\r'}
    else
        marker="$first_line"
    fi

    stripped=$(printf '%s\n' "$marker" |
        sed -e 's/^--[[:space:]]*//' -e 's/^#[[:space:]]*//')

    if [[ "$stripped" != ARC_FILE:* ]]; then
        return 1
    fi

    rel_path=$(printf '%s\n' "$stripped" |
        sed 's/^ARC_FILE:[[:space:]]*//')

    if [[ -z "$rel_path" || "$rel_path" == /* ]]; then
        return 1
    fi

    case "/$rel_path/" in
        */../*) return 1 ;;
    esac

    printf '%s\n' "$rel_path"
}

xdep() {
    if [[ $# -ne 1 || -z "$1" || "$1" == */* ]]; then
        echo "xdep: usage: xdep filename"
        return 1
    fi

    _arc_runtime_setup || return 1

    local file="$CB_DOWNLOADS/$1"
    if [[ ! -f "$file" ]]; then
        echo "xdep: file not found: $file"
        return 1
    fi

    local rel_path
    if ! rel_path=$(_arc_marker_path "$file"); then
        echo "xdep: ARC_FILE marker missing or invalid in $1"
        echo "xdep: use line 1, or line 2 after a shebang"
        return 1
    fi

    local dest="$PROJECT_ROOT/$rel_path"
    local dest_dir
    dest_dir=$(dirname "$dest") || return 1

    if ! mkdir -p "$dest_dir"; then
        echo "xdep: could not create directory: $dest_dir"
        return 1
    fi

    if ! mv "$file" "$dest"; then
        echo "xdep: deployment failed: $file"
        return 1
    fi

    echo "xdep: deployed $1 -> $dest"
}

xupkg() {
    if [[ $# -ne 1 || ! -f "$1" ]]; then
        echo "xupkg: usage: xupkg filename"
        return 1
    fi

    _arc_runtime_setup || return 1
    local file="$1"

    case "$file" in
        *.zip)
            _arc_require_command unzip || return 1
            unzip "$file" -d "$CB_DOWNLOADS/" || return 1
            ;;
        *.tar.gz|*.tgz)
            tar -xzf "$file" -C "$CB_DOWNLOADS/" || return 1
            ;;
        *)
            echo "xupkg: unsupported format: $file"
            echo "xupkg: supported formats: .zip, .tar.gz, .tgz"
            return 1
            ;;
    esac

    echo "xupkg: unpacked $file -> $CB_DOWNLOADS/"
}

xmd() {
    if [[ $# -lt 1 || $# -gt 2 || ! -f "$1" ]]; then
        echo "xmd: usage: xmd filename [format]"
        return 1
    fi

    local input="$1"
    local format="${2:-html}"

    local first_line
    first_line=$(sed -n '1p' "$input") || return 1
    first_line=${first_line%$'\r'}
    if [[ "$first_line" == '#!'* ]]; then
        echo "xmd: Markdown ARC_FILE marker must be on line 1: $input"
        return 1
    fi

    if [[ ! "$format" =~ ^[[:alnum:]_-]+$ ]]; then
        echo "xmd: invalid output format: $format"
        return 1
    fi

    if ! _arc_marker_path "$input" >/dev/null; then
        echo "xmd: ARC_FILE marker missing or invalid in $input"
        return 1
    fi

    _arc_require_command pandoc || return 1
    _arc_runtime_setup || return 1

    local name
    name=$(basename "$input") || return 1
    name=${name%.md}
    local output="$CB_TRANSFORMED/${name}.${format}"

    if ! tail -n +2 "$input" | pandoc -f markdown -t "$format" -o "$output"; then
        echo "xmd: transformation failed: $input"
        return 1
    fi

    echo "xmd: transformed $input -> $output"
}
