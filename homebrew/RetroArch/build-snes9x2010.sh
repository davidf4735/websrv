#!/usr/bin/env bash
#   Copyright (C) 2024 John Törnblom
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING. If not see
# <http://www.gnu.org/licenses/>.

VER="master"
URL="https://github.com/libretro/snes9x2010/archive/refs/heads/master.tar.gz"

SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"

if [[ -z "$PS5_PAYLOAD_SDK" ]]; then
    echo "error: PS5_PAYLOAD_SDK is not set"
    exit 1
fi

source "${PS5_PAYLOAD_SDK}/toolchain/prospero.sh" || exit 1

TEMPDIR=$(mktemp -d)
trap 'rm -rf -- "$TEMPDIR"' EXIT

wget -O $TEMPDIR/snes9x2010.tar.gz "${URL}" || exit 1
tar xf  $TEMPDIR/snes9x2010.tar.gz -C $TEMPDIR || exit 1

cd $TEMPDIR/snes9x2010-$VER || exit 1
${MAKE} || exit 1

mkdir -p "${SCRIPT_DIR}/.config/retroarch/cores" || exit 1
mv $TEMPDIR/snes9x2010-$VER/snes9x2010_libretro.so "${SCRIPT_DIR}/.config/retroarch/cores/" || exit 1
