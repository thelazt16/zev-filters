#!/usr/bin/env bash
set -euo pipefail

tmpdir="$(mktemp -d)"
outfile="filters.txt"

{
  echo "! Title: Febri merged filters"
  echo "! Description: Combined custom filter list for uBlock Origin"
  echo "! Version: $(date -u +%Y%m%d%H%M)"
  echo "! Expires: 7 days"
  echo
} > "$outfile"

while IFS= read -r url; do
  [ -z "$url" ] && continue
  case "$url" in \#*) continue ;; esac
  curl -fsSL "$url" >> "$tmpdir/all.txt"
  printf "\n" >> "$tmpdir/all.txt"
done < urls.txt

awk '!seen[$0]++' "$tmpdir/all.txt" >> "$outfile"