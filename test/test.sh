#!/bin/sh

cd /hphpc/hhvm/hphp

# Note: The /dev/ editing does not persist across layers for docker
rm -rf /dev/random
# Link /dev/random to /dev/urandom for MCrypt testing
ln -s /dev/urandom /dev/random

# see hphp/test/test.cpp and hphp/test/test_all.cpp
# for what these options mean. They are not documented.
# Briefly, the first option is the 'suite'
# The seocnd option is the 'which'
# and the third option is the 'set'
# Note that for convenience, a second way of calling tests
# can be done if the first option is suite::which (think C++ namespace style)
# Test::RunTestsImpl has a particularly confusing dispatch
# for the actual tests to run

# QuickTests -- runs just the tests listed in test_base_fast.inc
# These mostly test the parser
echo "Running QuickTests..."
./test/test '' '' QuickTests quiet
# TestExt -- runs just the tests listed in test_ext.inc
# These test various functions provided by the builtin extensions
echo "Running TestExt..."
./test/test '' '' TestExt quiet
# TestCodeRun::TestSanity - Verifies that we can compile code.
echo "Running TestCodeRun::TestSanity..."
./test/test TestCodeRun::TestSanity quiet

# Note that if we had called just ./test/test with no args,
# we would have done the entire TestCodeRun suite.
# This is VERY slow and will take hours to run
# Instead we just ran the bare minimum sanity checks
#./test/test TestCodeRun

