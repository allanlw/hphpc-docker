# HPHPC Docker

This repo contains everything required to build a functioning docker image with HPHPC 
(HipHop-PHP-Compiler) circa early February 2013.

## About

HPHPC is a PHP to C++ compiler that was developed originally developed at Facebook. It 
has largely been replaced by HHVM which uses a JIT based architecture instead. This 
repo contains a Dockerfile, and a git config for submodules to create a container to 
run legacy hphpc in, as one might expect to find it in early 2013. Compiling on a modern 
system, while theoretically possible, is likely to result in dependency hell, so using 
this Dockerfile can be convenient for experimentation.

To get started quickly, an example program and invocation are provided:

    docker run --rm -it awirth/hphpc:latest /hphpc/test/quick_start.sh

## Build

To build this repo:

    git submodule init && git submodule update --recursive
    docker build -t hphpc .

hphp is now built and located in /hphpc/hhvm/hphp/hphp/hphp in the container.

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

    docker run -v /home/allan/src/:/src -it awirth/hphpc:latest \
        /hphpc/hhvm/hphp/hphp/hphp -l 4 -k 1 -o /src/project/out /src/project/myprogram.php

### Test

Tests can be run from /hphpc/hhvm/hphp as `./test/test`. A handful of fast-ish tests 
are run while building the container by /hphpc/test/test.sh, which also contains some 
useful information about the arguments to pass to the test binary.

A full "TestcodeRun" test can take quite a long time. I've run it only once.

    time HPHP_VERBOSE=1 ./test/test TestCodeRun

Running this on a 4 core Digital Ocean box resulted in:

    ERROR: 79/2192 unit tests failed.

    real    945m58.334s
    user    3262m55.673s
    sys     466m0.929s

With more cores, this would likely go faster. I was not able to debug the reason that 
some tests failed.

## Gotchas

The last commit to use HPHPC is available at 
facebook/hhvm@b74a0da0623d72ac0d5dfc097ae307653b0e7f35 from Feb 11 2013, however this has a bug 
documented in facebook/hhvm#700 - so we use a commit from a few days earlier. 
Instructions for how to build on the hphp wiki are for current versions (hhvm), but 
build instructions for Ubuntu 12.04 (LTS) are available at 
[https://github.com/facebook/hhvm/wiki/Building-and-installing-HHVM-on-Ubuntu-12.04/2c4d922e8284805d05cc3917a0de2ffe22f69cfd](in 
an older revision).

A small patch (located in hhvm_fixes.patch) is applied to hhvm. This fixes a few 
issues. First, it prevents makeflags being propagated into HPHPc's internal invocation 
of make through environment variables, which was causing make to output a warning on 
stderr, breaking the test suite. Second, It applies a fix for bug facebook/hhvm#570 
which is an issue related to static initializer ordering. Third, it replaces a 
facebook-internal path to the php binary for testing with the system php.

In addition to the patch, the Dockerfile also configures the system to use bash as the 
system shell (not doing this breaks some scripts), and adds a symlink from 
/hphpc/hhvm/src to /hphpc/hhvm/hphp to work around some dangling references to the old 
name of this directory left over from this commit: 
facebook/hhvm@363d1bb20fe84b4cdc2dc0f4c7b1dd39d167a1f5

Finally, a few changes are made as small optimizations. Two scripts that are not happy 
being called outside of a git repository and break parallel builds are called manually 
before kicking off `make`, and when running the tests /dev/random is symlinked to 
/dev/urandom to avoid blocking in the MCrypt test (note this does not persist across 
docker layers).

HPHPC further includes a bunch of third party libraries inline directly. Upgrading all 
of them to modern versions would be quite the endeavor. Right now the container use 
Ubuntu 12.04 - I've tried some to port it to 14.04, but ran into some arcane issues 
that I wasn't able to debug well. I would be happy to accepting pull requests for 
upgrading OS or library versions, switching away from bundled libraries, or improving 
test coverage.

## License

The Dockerfile is licensed CC BY-SA 3.0, as it is a simple derivative of 
https://github.com/facebook/hhvm/wiki/Building-and-installing-HHVM-on-Ubuntu-12.04/2c4d922e8284805d05cc3917a0de2ffe22f69cfd 
which is CC BY-SA 3.0 as documented at https://github.com/facebook/hhvm/wiki/License

Everything else is a derivative of HHVM, so it is under the same licenses (PHP and Zend).
