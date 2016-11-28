# HPHPC Docker

This repo contains everything required to build a functioning docker image with HPHPC 
(HipHop-PHP-Compiler) circa early February 2013.

## About

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

## Build

To build this repo:

    git submodule init && git submodule update --depth=1 --recursive
    docker build -t hphpc .

hphp is now build and located in /hphpc/hhvm/bin/hphp in the container.

Tests can be run from /hphpc/hhvm/hphp as `./test/test`. Note that TestExtMcrypt
blocks on reading /dev/random.

## Run

Inside the container, an example invocation might be:

    /hphpc/hhvm/hphp/hphp/hphp -l 4 -k 1 -o out input.php

This has maximum verbose output (`-l 4`), uses `out` as the output directory (`-o 
out`), saves the output instead of just running it and them deleting the dir (`-k 1`), 
and uses input file input.php. Inside the `out` directory, there will be a file 
`program` which is the compiled program. The directory also has many useful 
intermediate files.

Note that compilation, even for simple programs, can take a few minutes. Be patient.

A full example run inside docker might look like:

    docker run -v /home/allan/hphpc-docker-full/test:/test \
        -it hphpc /hphpc/hhvm/hphp/hphp/hphp -l 4 -k 1 -o /test/out /test/test.php

## License

Anything in this repo is licensed CC BY-SA 3.0, as it is a simple derivative of 
https://github.com/facebook/hhvm/wiki/Building-and-installing-HHVM-on-Ubuntu-12.04/2c4d922e8284805d05cc3917a0de2ffe22f69cfd 
which is CC BY-SA 3.0 as documented at https://github.com/facebook/hhvm/wiki/License - 
this includes the Dockerfile and any test php scripts, but does NOT include any of the 
submodules, which are distributed separately.
