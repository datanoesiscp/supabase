#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./scripts/merge-env.sh [--examples] [--stdout] [--output FILE]

Combines shared, secret, and per-service env files into a single .env file.
Defaults to reading real files (.env.shared, .env.secrets, env/*.env)
and writing the merged result to ./supabase/.env.

Options:
  --examples   Use the *.example files instead of real values.
  --stdout     Print the merged output to stdout instead of writing a file.
  --output     Custom output path (implies not using --stdout).
USAGE
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )"/.. && pwd)"
ENV_DIR="${ROOT_DIR}/env"
OUTPUT="${ROOT_DIR}/.env"
USE_EXAMPLES=false
TO_STDOUT=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --examples)
      USE_EXAMPLES=true
      shift
      ;;
    --stdout)
      TO_STDOUT=true
      shift
      ;;
    --output)
      [[ $# -ge 2 ]] || { echo "Missing value for --output" >&2; usage; exit 1; }
      OUTPUT="$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if $TO_STDOUT && [[ -n "${OUTPUT}" ]]; then
  : # printing to stdout, ignore output path
fi

suffix=""
if $USE_EXAMPLES; then
  suffix=".example"
fi

sources=()
for candidate in "${ROOT_DIR}/.env.shared${suffix}" "${ROOT_DIR}/.env.secrets${suffix}"; do
  if [[ -f "$candidate" ]]; then
    sources+=("$candidate")
  fi
done

shopt -s nullglob
if $USE_EXAMPLES; then
  service_files=("${ENV_DIR}"/env.*${suffix})
  if [[ ${#service_files[@]} -eq 0 ]]; then
    service_files=("${ENV_DIR}"/env.*)
  fi
else
  service_files=("${ENV_DIR}"/env.*)
fi
shopt -u nullglob

if [[ ${#service_files[@]} -gt 0 ]]; then
  IFS=$'\n' service_files=($(printf '%s\n' "${service_files[@]}" | sort))
else
  service_files=()
fi

sources+=("${service_files[@]}")

if [[ ${#sources[@]} -eq 0 ]]; then
  echo "No environment files found. Nothing to merge." >&2
  exit 1
fi

merge() {
  for file in "${sources[@]}"; do
    rel="${file#${ROOT_DIR}/}"
    echo "# --- $rel ---"
    cat "$file"
    echo
  done
}

if $TO_STDOUT; then
  merge
else
  tmp="${OUTPUT}.tmp"
  merge > "$tmp"
  mv "$tmp" "${OUTPUT}"
  echo "Wrote merged env to ${OUTPUT}"
fi
