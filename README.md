# About

HPHPC is a PHP to C compiler that was developed originally developed at Facebook. It 
has largely been replaced by HHVM which uses a JIT based architecture instead. These 
are some notes for how to build/install the legacy HPHPC, which will let you compile 
PHP code into C code.

The last commit to use HPHPC is available at 
https://github.com/facebook/hhvm/tree/use-hphpc commit 
b74a0da0623d72ac0d5dfc097ae307653b0e7f35 from Feb 11 2013, however this has a bug 
documented in https://github.com/facebook/hhvm/issues/700 - so we use a commit from a 
few days earlier. Instructions for how to build on the hphp wiki are for current 
versions (hhvm), but build instructions for Ubuntu 12.04 (LTS) are available at: 
https://github.com/facebook/hhvm/wiki/Building-and-installing-HHVM-on-Ubuntu-12.04/2c4d922e8284805d05cc3917a0de2ffe22f69cfd 
(note the old revision).

This repo contains a Dockerfile, and a git config for submodules to create a container 
to run legacy hphpc in, as one might exect to find it in early 2013. Compiling on a 
modern system, while theoretically possible, is likely to result in dependency hell, so 
using this Dockerfile can be convenient for experimentation.

Note that HPHPC further includes a bunch of third party libraries inline directly (as 
git submodules). Upgrading all of them to modern versions would be quite the endevour.

# Build

To build this repo:

    git submodule init && git submodule update --depth=1 --recursive
    docker build -t hphpc .

hphp is now build and located in /hphpc/hhvm/bin/hphp in the container.

Tests can be run from /hphpc/hhvm/hphp as `./test/test`. Note that TestExtMcrypt
blocks on reading /dev/random.
