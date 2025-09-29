# Environment Configuration Layout

The Supabase stack now sources its configuration from three buckets:

1. `.env.secrets` - credentials and tokens that should never be committed
2. `.env.shared` - cross-service defaults (service-agnostic values such as expiries)
3. `env/env.*` - service-scoped switches and toggles (one file per container)

Edit the files in `env/` directly, then run `./scripts/merge-env.sh` to stitch everything together into a single `.env` file that Docker Compose can consume. Pass `--examples` if you just want to regenerate a sample `.env` from the example files.
