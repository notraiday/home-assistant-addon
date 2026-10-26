# syntax=docker/dockerfile:1
#
# Music Assistant with the Spotify proxy fork installed on top of the nightly server image.
#
# The server is installed while the image is built, so starting the App installs nothing.
# To move to a newer commit of the fork: change SERVER_REF below and bump `version` in
# config.yaml, which makes Home Assistant offer an update and rebuild the image.
#
FROM ghcr.io/music-assistant/server:nightly

ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

ARG SERVER_REPO=notraiday/ma-server-spotify-proxy
# the claude/spotify-proxy branch of the fork, pinned so a rebuild gives the same server
ARG SERVER_REF=85ea972d54ae7d23715ce34a988c881a2886b124

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# git and the compilers are only needed to install the fork and any dependency it pins to a git ref
RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends build-essential cmake ninja-build git curl ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY install-server.sh /tmp/install-server.sh
RUN SERVER_REPO="${SERVER_REPO}" SERVER_REF="${SERVER_REF}" sh /tmp/install-server.sh \
  && rm /tmp/install-server.sh

VOLUME [ "/data" ]
EXPOSE 8095

# /app is already world-writable here; a recursive chmod would copy the whole venv into a layer
RUN chmod 777 -R /tmp

COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
