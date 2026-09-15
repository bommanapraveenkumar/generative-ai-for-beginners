#!/usr/bin/env bash
# Idempotent bootstrap for the Generative AI for Beginners course.
#
# The repo pins data-science dependencies (numpy 1.24.2, pandas 1.5.3,
# matplotlib 3.7.0) that only publish wheels for Python <= 3.11, while the
# default base image ships Python 3.12. We therefore provision Python 3.11
# with uv and install every Python dependency into a project-local .venv.
set -euo pipefail

cd "$(dirname "$0")/.."

export PATH="$HOME/.local/bin:$PATH"

# 1. Ensure uv is available (used to fetch Python 3.11 and manage the venv).
if ! command -v uv >/dev/null 2>&1; then
  pip install --user --quiet uv
fi

# 2. Provision Python 3.11 (cached by uv after the first run).
uv python install 3.11

# 3. Create/refresh the virtualenv used for all lesson Python code + Jupyter.
uv venv --python 3.11 --allow-existing .venv

# 4. Install the course Python dependencies (notebooks, apps, Jupyter stack).
uv pip install --python .venv/bin/python --upgrade pip
uv pip install --python .venv/bin/python -r requirements.txt

# 5. Install Node dependencies for the TypeScript lessons and docs tooling.
npm ci

echo "Environment setup complete. Activate Python with: source .venv/bin/activate"
