#!/bin/sh
# Installs the server from a GitHub repository on top of the server image.
# Expects SERVER_REPO (owner/repo) and SERVER_REF (branch, tag or commit) in the environment.
set -eu

# a flaky connection to GitHub should not fail the whole build on the first hiccup
retry() {
    attempt=1
    until "$@"; do
        if [ "$attempt" -ge 4 ]; then
            echo "Giving up after $attempt attempts: $*" >&2
            return 1
        fi
        echo "Attempt $attempt failed, trying again in 15 seconds" >&2
        attempt=$((attempt + 1))
        sleep 15
    done
}

echo "Installing the server from ${SERVER_REPO}@${SERVER_REF}"

# the bundled app variables live inside the package, so a source install removes them
site_packages=$(python -c 'import sysconfig; print(sysconfig.get_path("purelib"))')
bundled_app_secrets="${site_packages}/music_assistant/helpers/app_secrets.json"
if [ -f "$bundled_app_secrets" ]; then
    cp "$bundled_app_secrets" /tmp/app_secrets.json
fi

retry uv pip install --no-cache --link-mode=copy \
    -r "https://raw.githubusercontent.com/${SERVER_REPO}/${SERVER_REF}/requirements_all.txt"
retry uv pip install --no-cache --link-mode=copy \
    "git+https://github.com/${SERVER_REPO}@${SERVER_REF}"

if [ -f /tmp/app_secrets.json ]; then
    cp /tmp/app_secrets.json "$bundled_app_secrets"
    rm -f /tmp/app_secrets.json
    echo "Bundled app variables restored"
fi
echo "Installed: $(python -c 'import importlib.metadata; print(importlib.metadata.version("music-assistant"))')"
