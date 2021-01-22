# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libretro-mame"
PKG_VERSION="f0f4ea6c5bdac62fe74491dcd205c1cd77016ae0"
PKG_SHA256="acdee7eeac28de1ab257cd2593c3d3266863875139d9a201f572d8044e3eb96e"
PKG_ARCH="x86_64 arm"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mame"
PKG_URL="https://github.com/libretro/mame/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain kodi-platform"
PKG_LONGDESC="game.libretro.mame: MAME for Kodi"
PKG_BUILD_FLAGS="-gold -lto"
PKG_TOOLCHAIN="make"

PKG_LIBNAME="mame_libretro.so"
PKG_LIBPATH="${PKG_LIBNAME}"
PKG_LIBVAR="MAME_LIB"

pre_make_target() {
  PKG_MAKE_OPTS_TARGET=" \
    REGENIE=1 VERBOSE=1 NOWERROR=1 PYTHON_EXECUTABLE=python3 CONFIG=libretro \
    LIBRETRO_OS="unix" ARCH="" PROJECT="" LIBRETRO_CPU="${ARCH}" DISTRO="debian-stable" \
    CROSS_BUILD="1" OVERRIDE_CC="${CC}" OVERRIDE_CXX="${CXX}" \
    TARGET="mame" SUBTARGET="arcade" PLATFORM="${ARCH}" RETRO=1 OSD="retro""

  if [ "${ARCH}" = "arm" ]; then
    PKG_MAKE_OPTS_TARGET+=" NOASM="1" ARCHITECTURE="""
  elif [ "${ARCH}" = "x86_64" ]; then
    PKG_MAKE_OPTS_TARGET+=" NOASM="0" PTR64="1""
  fi
}

post_make_target() {
  mv ${PKG_BUILD}/mamearcade_libretro.so ${PKG_BUILD}/mame_libretro.so
}

makeinstall_target() {
  mkdir -p ${SYSROOT_PREFIX}/usr/lib/cmake/${PKG_NAME}
  cp ${PKG_LIBPATH} ${SYSROOT_PREFIX}/usr/lib/${PKG_LIBNAME}
  echo "set(${PKG_LIBVAR} ${SYSROOT_PREFIX}/usr/lib/${PKG_LIBNAME})" > ${SYSROOT_PREFIX}/usr/lib/cmake/${PKG_NAME}/${PKG_NAME}-config.cmake
}
