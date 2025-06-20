#!/usr/bin/env bash
set -ex

MYNCPU=$(( CPU_COUNT > 8 ? 8 : CPU_COUNT ))

# drop linker flags that spuriously remove linkage with libgslcblas
LDFLAGS="${LDFLAGS/-Wl,-dead_strip_dylibs/}"

# debug dump of what's actually installed
echo "===== PREFIX is: $PREFIX ====="
echo "===== Listing $PREFIX/lib ====="
ls -al "$PREFIX/lib" || true
echo "================================"
echo "===== Grep for libobjcryst in $PREFIX/lib ====="
ls -1 "$PREFIX/lib" | grep -i objcryst || echo ">>> libobjcryst NOT FOUND <<<"
echo "================================"

# use macos SDK
if [[ $build_platform == osx-64 ]]; then
  export CXXFLAGS="${CXXFLAGS} -isysroot ${CONDA_BUILD_SYSROOT}"
fi

# Apply sconscript.local customizations.
cp "${RECIPE_DIR}/sconscript.local" .

# Build and install the library.
scons -j $MYNCPU lib install prefix=$PREFIX
