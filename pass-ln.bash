#!/usr/bin/env bash

# Note: set -e has no effect whatsoever, due to a bug^H^H^Hfun,
# clearly documented feature of POSIX [1], combined with the fact that
# Pass (seemingly by accident) invokes extensions in a subshell.
#
# Therefore, we have to litter '|| exit' after every command in the
# script, unfortunately.
#
# [1]: https://unix.stackexchange.com/q/65532
set -uo pipefail

ln_usage() {
    echo 'Usage: pass ln target link-name'
}

VERSION=git

cmd_version() {
    if [[ "${VERSION}" != git ]]; then
        printf -- 'pass-ln %s\n' "${VERSION}"
        exit
    fi
    local ver="$(git -C "$(dirname "$0")" describe --tags --dirty 2>/dev/null ||:)"
    if [[ -n "${ver}" ]]; then
        printf -- 'pass-ln %s (from git)\n' "${ver}"
        exit
    fi
    die "could not determine version"
}

cmd_ln() {
    if [[ "$#" -ne 2 ]]; then
        ln_usage >&2; exit 1
    fi
    check_sneaky_paths "$@"
    local target="$1"
    local link_shorthand_name="$2"
    local link_name="${link_shorthand_name}"
    if [[ "${link_shorthand_name}" == */ ]]; then
        link_name="${link_name%%/}/$(basename -- "${target}")"
    fi
    local target_filename="${target}"
    local link_filename="${link_name}"
    if [[ -f "${PREFIX}/${target}.gpg" ]]; then
        target_filename+=".gpg"
        link_filename+=".gpg"
    elif [[ -d "${PREFIX}/${target}" ]]; then
        : # Nothing to do
    else
        die "Error: ${target} is not in the password store."
    fi
    if [[ -e "${PREFIX}/${link_filename}" || -L "${PREFIX}/${link_filename}" ]]; then
        die "Error: refusing to overwrite ${link_name}."
    fi
    link_dir="$(dirname -- "${link_filename}")" || exit
    realpath_cmd="realpath"
    if [[ "$(uname)" == "Darwin" ]]; then
        if command -v grealpath &>/dev/null; then
            # On macOS, use GNU realpath as provided via `coreutils`
            # Homebrew formula if available
            realpath_cmd="grealpath"
        fi
    fi
    target_relative_path="$("$realpath_cmd" -m --relative-to="${link_dir}" -- "${target_filename}")" || exit
    set_git "${PREFIX}/${link_filename}"
    mkdir -p "${PREFIX}/${link_dir}" || exit
    ln -s "${target_relative_path}" "${PREFIX}/${link_filename}" || exit
    git_add_file "${PREFIX}/${link_filename}" "Alias ${target} to ${link_name}."
}

if [[ "$#" -eq 0 ]]; then
    ln_usage >&2; exit 1
fi

case "$1" in
    help|--help|-h) ln_usage           ;;
    version|--version|-v) cmd_version  ;;
    *) cmd_ln "$@"                     ;;
esac

# Pass will source us and then exit unconditionally with status zero,
# ignoring whatever we did. Avoid that and force an exit after
# completion.
exit
