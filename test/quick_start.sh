#!/bin/bash

echo "Compiling example program with hphpc..."

# Shows the Cmake output, so people don't get impatient
export HPHP_VERBOSE=1

/hphpc/hhvm/hphp/hphp/hphp -k 1 -l 1 -o /hphpc/test/hello_world_out /hphpc/test/hello_world/hello_world.php

cd /hphpc/test/hello_world_out

echo ""
echo ""
echo "Done building example program!"
echo "Explore this directory to see the greatness of HPHPC"

exec bash
