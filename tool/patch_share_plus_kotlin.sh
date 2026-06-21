#!/usr/bin/env bash
# share_plus still declares kotlin-android in its Android Gradle file, which
# triggers Flutter's built-in Kotlin migration warning during release builds.
# Remove the explicit plugin declaration so Flutter can manage Kotlin for the
# plugin module. Upstream: https://github.com/fluttercommunity/plus_plugins/issues/3831
set -euo pipefail

pub_cache="${PUB_CACHE:-$HOME/.pub-cache}"

mapfile -t gradle_files < <(
  find "$pub_cache/hosted/pub.dev" -path '*/share_plus-*/android/build.gradle*' 2>/dev/null || true
)

if ((${#gradle_files[@]} == 0)); then
  echo "share_plus Android Gradle file not found in pub cache; skipping KGP patch." >&2
  exit 0
fi

for gradle_file in "${gradle_files[@]}"; do
  if grep -qE 'kotlin-android|org\.jetbrains\.kotlin\.android' "$gradle_file"; then
    sed -i \
      -e '/id("kotlin-android")/d' \
      -e '/id("org.jetbrains.kotlin.android")/d' \
      -e "/apply plugin: 'kotlin-android'/d" \
      -e '/apply plugin: "kotlin-android"/d' \
      "$gradle_file"
    echo "Patched share_plus KGP declaration in $gradle_file"
  fi
done
