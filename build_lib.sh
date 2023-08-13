#!/bin/bash
TEMP=$(mktemp -d)
SRC="pcre-8.42"
echo "Using temp directory $TEMP to build $SRC"
(
  cp "$SRC.tar.gz" "$TEMP"
  cd "$TEMP"
  tar -xf "$SRC.tar.gz"
  (
    cd "$SRC"
    ./configure \
      --enable-jit \
      --enable-utf \
      --disable-shared \
      --disable-cpp \
      --enable-newline-is-any \
      --with-match-limit=500000 \
      --with-match-limit-recursion=50000
    make
  )
)
PLATFORM="$(uname -sm)"
case "${PLATFORM}" in
  Linux*)  OUTPUT=libpcre_linux.a;;
  "Darwin x86_64"*) OUTPUT=libpcre_darwin_x86_64.a;;
  "Darwin arm64"*) OUTPUT=libpcre_darwin_arm64.a;;
  *)       OUTPUT=libpcre.a
esac
cp "$TEMP/$SRC/.libs/libpcre.a" "$OUTPUT"
echo "Copied static library to $OUTPUT"
rm -rf "$TEMP"
