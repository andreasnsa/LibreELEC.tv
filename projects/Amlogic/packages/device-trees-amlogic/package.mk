################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
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

PKG_NAME="device-trees-amlogic"
PKG_VERSION="68267ba"
PKG_SHA256="45a014e2dd9c6b69e06bd980e467925ae36208017d9ef16dde4a58e47f830c94"
PKG_LICENSE="GPL"
PKG_URL="https://github.com/LibreELEC/device-trees-amlogic/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_IS_KERNEL_PKG="yes"
PKG_TOOLCHAIN="manual"

make_target() {
  # Enter kernel directory
  pushd $BUILD/linux-$(kernel_version) > /dev/null

  # Device trees already present in kernel tree we want to include
  EXTRA_TREES=(gxbb_p201.dtb gxl_p212_1g.dtb gxl_p212_2g.dtb \
               gxm_q200_2g.dtb gxm_q201_1g.dtb gxm_q201_2g.dtb)

  # Add "le-dtb-id" and add trees to the list
  pushd arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic > /dev/null
  for f in ${EXTRA_TREES[@]}; do
    LE_DT_ID="${f/.dtb/}"
    echo -e "/ {\n\tle-dt-id = \"$LE_DT_ID\";\n};" >> "${f/.dtb/.dts}"
    DTB_LIST="$DTB_LIST $f"
  done
  popd > /dev/null

  # Copy all device trees to kernel source folder and create a list
  for f in $PKG_BUILD/*.dts; do
    DTB_NAME="$(basename $f .dts).dtb"
    cp -f $f arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/
    DTB_LIST="$DTB_LIST $DTB_NAME"
  done

  # Compile device trees
  LDFLAGS="" make $DTB_LIST
  mv arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/*.dtb $PKG_BUILD

  popd > /dev/null
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/bootloader
  cp -a $PKG_BUILD/*.dtb $INSTALL/usr/share/bootloader
}
