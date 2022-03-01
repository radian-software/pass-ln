#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo 'Usage: pass ln target link-name'
}

die() {
    echo >&2 "$@"
    exit 1
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
        usage >&2; exit 1
    fi
    check_sneaky_paths "$@"
    local target="$1"
    local link_name="$2"
    local target_is_dir=
    local target_realname=
    if [[ -d "${PREFIX}/${target}" ]]; then
        target_is_dir=true
        target_realname="${target}"
    elif [[ -f "${PREFIX}/${target}.gpg" ]]; then
        target_realname="${target}.gpg"
    else
        die "Error: ${target} is not in the password store."
    fi
    local link_name_is_dir=
    if [[ "${link_name}" == */ || -e "${PREFIX}/${link_name%/}" ]]; then
        link_name_is_dir=true
    fi
    if [[ -n "${link_name_is_dir}" ]]; then
        link_name="${link_name%/}/$(basename -- "${target}")"
    fi
    local link_realname="${link_name}"
    if [[ -z "${target_is_dir}" ]]; then
        link_realname+=".gpg"
    fi
    link_name_dir="$(dirname -- "${link_name}")"
    target_relative_path="$(realpath -m --relative-to="${link_name_dir}" -- "${target_realname}")"
    set_git "${PREFIX}/${link_realname}"
    mkdir -p "${PREFIX}/${link_name_dir}"
    ln -s "${target_relative_path}" "${PREFIX}/${link_realname}"
    git_add_file "${PREFIX}/${link_realname}" "Alias ${target} to ${link_name}."
}

if [[ "$#" -eq 0 ]]; then
    usage >&2; exit 1
fi

case "$1" in
    help|--help|-h) usage              ;;
    version|--version|-v) cmd_version  ;;
    *) cmd_ln "$@"                     ;;
esac
