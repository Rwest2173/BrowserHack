#!/bin/bash

EMCC=~/src/emscripten/emcc
EMCCFLAGS=-O3 -Oz
JOBS=4
MYDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

stage1() {
sh sys/unix/setup.sh
make CC=$EMCC -j$JOBS
}

# link JS
stage2() {
pushd build
  cp ../src/nethack nethack.bc 
  $EMCC nethack.bc \
    -o browserhack.js \
    $EMCCFLAGS \
    -s EMTERPRETIFY=1 \
    -s EMTERPRETIFY_ASYNC=1 \
    --memory-init-file 1 \
    --js-library ../win/web/nethack_lib.js \
    --preload-file nethack \

popd
cp build/browserhack.js web/
cp build/browserhack.js.mem web/
cp build/browserhack.data web/
}

stage1
#stage2
