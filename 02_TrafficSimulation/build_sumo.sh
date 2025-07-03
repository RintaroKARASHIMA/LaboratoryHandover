#!/usr/bin/env bash
# ~/workspace/TrafficSimulation/build_sumo.sh
# set -euo pipefail

###############################################################################
# 0. グローバル設定
###############################################################################
PREFIX="$HOME/workspace/TrafficSimulation/local"
BUILD="$HOME/workspace/TrafficSimulation/build"
CPU=$(nproc)

# 旧 lib64 を一掃しておく（初回ビルドなら何も起こらない）
rm -rf "$PREFIX/lib64"

mkdir -p "$PREFIX" "$BUILD"
cd "$BUILD"

# ── 自前ライブラリを toolchain 全体で最優先 ─────────────────────────────
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"
export CMAKE_PREFIX_PATH="$PREFIX"
export LD_LIBRARY_PATH="$PREFIX/lib:${LD_LIBRARY_PATH:-}"

# CMake に「必ず lib に置け」と指示（ほぼ全プロジェクトが従う）
export CMAKE_INSTALL_LIBDIR=lib

download () {
  local url="$1" file
  file=$(basename "$url")
  [ -f "$file" ] || curl -Lf --retry 4 -O "$url"
  tar tzf "$file" &>/dev/null || { echo "❌  $file is bad"; rm -f "$file"; exit 1; }
}

###############################################################################
# 2-1. Xerces-C++ 3.2.5  (Autotools)
###############################################################################
download https://archive.apache.org/dist/xerces/c/3/sources/xerces-c-3.2.5.tar.gz
tar xf xerces-c-3.2.5.tar.gz
mkdir -p xerces-build && cd xerces-build
../xerces-c-3.2.5/configure \
  --prefix="$PREFIX" --libdir="$PREFIX/lib" --disable-static \
  CXXFLAGS="-O3 -march=native"
make -j"$CPU" && make install
cd "$BUILD"

###############################################################################
# 2-2. PROJ 9.4.0  (CMake)
###############################################################################
download https://download.osgeo.org/proj/proj-9.4.0.tar.gz
tar xf proj-9.4.0.tar.gz
mkdir -p proj-build && cd proj-build
cmake ../proj-9.4.0 \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_INSTALL_RPATH="$PREFIX/lib"
make -j"$CPU" && make install
cd "$BUILD"

###############################################################################
# 2-3. GDAL 3.9.0  (CMake, Python/SWIG 無効)
###############################################################################
download https://download.osgeo.org/gdal/3.9.0/gdal-3.9.0.tar.gz
tar xf gdal-3.9.0.tar.gz
mkdir -p gdal-build && cd gdal-build
cmake ../gdal-3.9.0 \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DPROJ_ROOT="$PREFIX" \
  -DGDAL_USE_PROJ=ON \
  -DGDAL_ENABLE_DRIVER_PYTHON=OFF \
  -DGDAL_BUILD_OPTIONAL_DRIVERS=OFF \
  -DGDAL_ENABLE_PLUGINS=OFF \
  -DGDAL_ENABLE_PYTHON=OFF \
  -DCMAKE_INSTALL_RPATH="$PREFIX/lib"
make -j"$CPU" && make install
cd "$BUILD"

###############################################################################
# 2-4. GL2PS 1.4.2  (CMake)
###############################################################################
download https://geuz.org/gl2ps/src/gl2ps-1.4.2.tgz
tar xf gl2ps-1.4.2.tgz
mkdir -p gl2ps-build && cd gl2ps-build
cmake ../gl2ps-1.4.2 \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_RPATH="$PREFIX/lib"
make -j"$CPU" && make install
cd "$BUILD"

###############################################################################
# 2-5. FOX-Toolkit 1.6.59  (Autotools)
###############################################################################
download http://fox-toolkit.org/ftp/fox-1.6.59.tar.gz
tar xf fox-1.6.59.tar.gz
mkdir -p fox-build && cd fox-build
../fox-1.6.59/configure \
  --prefix="$PREFIX" --libdir="$PREFIX/lib" \
  --with-opengl=yes --enable-shared --disable-static \
  CFLAGS="-O3 -march=native" CXXFLAGS="-O3 -march=native"
make -j"$CPU" && make install
cd "$BUILD"

###############################################################################
# 3. SUMO 1.23.0  (CMake)
###############################################################################
rm -rf sumo                                  # 旧ツリーを消去
git clone --depth 1 --branch v1_23_0 https://github.com/eclipse-sumo/sumo.git
mkdir -p sumo-build && cd sumo-build
cmake ../sumo \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_FLAGS="-O3 -march=native" \
  -DXERCESC_ROOT="$PREFIX" \
  -DPROJ_ROOT="$PREFIX" \
  -DGDAL_ROOT="$PREFIX" \
  -DFOX_ROOT="$PREFIX" \
  -DWITH_GUI=ON \
  -DCMAKE_INSTALL_RPATH="$PREFIX/lib"
cmake --build . -j"$CPU"
cmake --install .

echo -e "\n✅  Build finished — binaries are in $PREFIX/bin"
