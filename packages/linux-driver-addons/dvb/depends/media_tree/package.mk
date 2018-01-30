################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017-present Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="media_tree"
PKG_VERSION="2017-12-06-b32a2b42f76c"
PKG_SHA256="90a6b5b015bbb5583a6c72880f8b89ed8b3671ca64c713a00ec3467fbb84cdc4"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://git.linuxtv.org/media_tree.git"
PKG_URL="http://linuxtv.org/downloads/drivers/linux-media-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="driver"
PKG_LONGDESC="Source of Linux Kernel media_tree subsystem to build with media_build."
PKG_TOOLCHAIN="manual"

unpack() {
  mkdir -p $PKG_BUILD/
  tar -xf $SOURCES/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.bz2 -C $PKG_BUILD/

  # hack/workaround for borked upstream kernel/media_build
  # without removing atomisp there a lot additional includes that 
  # slowdown build process after modpost from 3min to 6min
  # even if atomisp is disabled via kernel.conf
  rm -rf $PKG_BUILD/drivers/staging/media/atomisp
  sed -i 's|^.*drivers/staging/media/atomisp.*$||' \
    $PKG_BUILD/drivers/staging/media/Kconfig

  # hack/workaround to make aml work
  if [ $LINUX = "amlogic-3.14" -o $LINUX = "amlogic-3.10" ]; then
    # Copy amlvideodri module
    mkdir -p $PKG_BUILD/drivers/media/amlogic/
    cp -a "$(kernel_path)/drivers/amlogic/video_dev" "$PKG_BUILD/drivers/media/amlogic"
    sed -i 's,common/,,g; s,"trace/,",g' `find $PKG_BUILD/drivers/media/amlogic/video_dev/ -type f`
    sed -i 's/case VMODE_NTSC_M://g' "$PKG_BUILD/drivers/media/amlogic/video_dev/amlvideo2.c"
    sed -i 's/case VMODE_PAL_M://g' "$PKG_BUILD/drivers/media/amlogic/video_dev/amlvideo2.c"
    sed -i 's/case VMODE_PAL_M://g' "$PKG_BUILD/drivers/media/amlogic/video_dev/amlvideo2.c"
    # Copy videobuf-res module
    cp -a "$(kernel_path)/drivers/media/v4l2-core/videobuf-res.c" "$PKG_BUILD/drivers/media/v4l2-core/"
    cp -a "$(kernel_path)/include/media/videobuf-res.h" "$PKG_BUILD/include/media/"
  fi

  if [ $DEVICE = "S905" -o $DEVICE = "S912" ]; then
    mkdir -p  "$PKG_BUILD/drivers/media/dvb-avl/"
    # Copy avl6862 driver
    cp -a $(kernel_path)/drivers/amlogic/dvb-avl "$PKG_BUILD/drivers/media/"
  fi
  if listcontains "$ADDITIONAL_DRIVERS" "wetekdvb"; then
    # Copy wetek dvb driver
    cp -a $(kernel_path)/drivers/amlogic/wetek/ "$PKG_BUILD/drivers/media/"
    cp -a $(get_build_dir wetekdvb)/driver/wetekdvb_play2.ko $(get_build_dir hauppauge)/v4l/wetekdvb.ko
    echo "obj-y += wetek/" >> "$PKG_BUILD/drivers/media/Makefile"
  fi
}
