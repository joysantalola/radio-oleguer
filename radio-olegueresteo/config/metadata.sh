#!/bin/sh
set -eu

ICECAST_HOST="icecast-olegueresteo"
ICECAST_PORT="8000"
ADMIN_USER="admin"
ADMIN_PASS="admin123"

MOUNT="/radio-olegueresteo.mp3"   # <- mount on vols posar el títol
AUDIO_DIR="/audio"

# Envia metadades a Icecast (Stream Title)
send_meta () {
  TITLE="$1"
  # URL-encode mínim (espais i alguns caràcters típics)
  ENCODED=$(printf '%s' "$TITLE" | sed 's/%/%25/g; s/ /%20/g; s/&/%26/g; s/+/%2B/g; s/#/%23/g; s/?/%3F/g')
  curl -sS -u "${ADMIN_USER}:${ADMIN_PASS}" \
    "http://${ICECAST_HOST}:${ICECAST_PORT}/admin/metadata?mount=${MOUNT}&mode=updinfo&song=${ENCODED}" \
    >/dev/null
  echo "Metadata updated: $TITLE"
}

# Loop infinit: recorre tots els mp3 del directori
while true; do
  for f in "$AUDIO_DIR"/*.mp3; do
    [ -f "$f" ] || continue
    BASE=$(basename "$f")
    TITLE="${BASE%.mp3}"
    send_meta "$TITLE"
    # Espera aproximadament la durada del fitxer (segons)
    DUR=$(ffprobe -v error -show_entries format=duration -of default=nk=1:nw=1 "$f" | awk '{printf("%d\n",$1+0.5)}')
    [ "$DUR" -gt 0 ] 2>/dev/null || DUR=180
    sleep "$DUR"
  done
done
