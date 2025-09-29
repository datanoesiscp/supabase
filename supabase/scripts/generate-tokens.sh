#!/usr/bin/env bash
set -euo pipefail

# Generates a fresh supabase/.env.secrets file with random credentials and JWTs.
# All generated values are for local development only. Never use them in production.

usage() {
  cat <<'USAGE'
Usage: ./scripts/generate-tokens.sh [--force] [--dry-run] [--output FILE]

Writes supabase/.env.secrets with freshly generated credentials and tokens.

Options:
  --force       Overwrite an existing secrets file without prompting.
  --dry-run     Print the generated secrets to stdout instead of writing a file.
  --output FILE Custom output location (defaults to supabase/.env.secrets).
USAGE
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )"/.. && pwd)"
OUTPUT="${ROOT_DIR}/.env.secrets"
FORCE=false
DRY_RUN=false

while [[ 0 -gt 0 ]]; do
  case "" in
    --force)
      FORCE=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --output)
      [[ 0 -ge 2 ]] || { echo "Missing value for --output" >&2; usage; exit 1; }
      OUTPUT=""
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: " >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -f "" && "" = false && "" = false ]]; then
  echo "Refusing to overwrite existing . Use --force or --dry-run." >&2
  exit 1
fi

rand_url() {
  local bytes=32
  openssl rand -base64 "" | tr '+/' '-_' | tr -d '=
'
}

rand_hex() {
  local bytes=32
  openssl rand -hex ""
}

ISS="supabase"
YEARS=10
NOW=$(date +%s)
EXP=0

base64url() {
  openssl base64 -A | tr '+/' '-_' | tr -d '=
'
}

sign_hs256() {
  local header_payload="" secret=""
  printf '%s' "" |\
    openssl dgst -binary -sha256 -hmac "" | base64url
}

make_jwt() {
  local role="" secret=""
  local header={'""alg"":""HS256"",""typ"":""JWT""}'
  local payload="{"role":"","iss":"","iat":,"exp":}"
  local header_b64=
  local payload_b64=
  local unsigned="."
  local signature=
  printf '%s.%s' "" ""
}

JWT_SECRET=
POSTGRES_PASSWORD=
ANON_KEY=
SERVICE_ROLE_KEY=

cat >".tmp" <<SECRETS
############
# Secrets
# Generated $(date -u +"%Y-%m-%dT%H:%M:%SZ")
############

POSTGRES_PASSWORD=
JWT_SECRET=
ANON_KEY=
SUPABASE_ANON_KEY=
SERVICE_ROLE_KEY=
SUPABASE_SERVICE_KEY=
DASHBOARD_USERNAME=admin
DASHBOARD_PASSWORD=
SECRET_KEY_BASE=
VAULT_ENC_KEY=
SMTP_USER=mailer_
SMTP_PASS=
LOGFLARE_PUBLIC_ACCESS_TOKEN=
LOGFLARE_PRIVATE_ACCESS_TOKEN=
OPENAI_API_KEY=
SECRETS

if ; then
  cat ".tmp"
  rm ".tmp"
  exit 0
fi

mv ".tmp" ""
chmod 600 ""

echo "Wrote new secrets to "
