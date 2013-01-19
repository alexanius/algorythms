#!/bin/bash

# This is file for testing speed and correctness of ocaml program
#
# This is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.
#
# @author alexanius

# geterate -O0 executable
g++ -std=c++0x -Wall -pedantic -Werror -O0 main.cpp sieve_of_eratosthenes.cpp -o slow.out
# geterate -O3 executable
g++ -std=c++0x -Wall -pedantic -Werror -O3 main.cpp sieve_of_eratosthenes.cpp -o fast.out

# speed test
function speed_test()
{
    echo
    echo Testing 1000
    /usr/bin/time -f "%e %M" bash -c "echo 1000 | $1 > /dev/null"

    echo
    echo Testing 10.000
    /usr/bin/time -f "%e %M" bash -c "echo 10000 | $1 > /dev/null"

    echo
    echo Testing 100.000
    /usr/bin/time -f "%e %M" bash -c "echo 100000 | $1 > /dev/null"

    echo
    echo Testing 1.000.000
    /usr/bin/time -f "%e %M" bash -c "echo 1000000 | $1 > /dev/null"

    echo
    echo Testing 10.000.000
    /usr/bin/time -f "%e %M" bash -c "echo 10000000 | $1 > /dev/null"

    echo
    echo Testing 100.000.000
    /usr/bin/time -f "%e %M" bash -c "echo 100000000 | $1 > /dev/null"

    echo
    echo Testing 1.000.000.000
    /usr/bin/time -f "%e %M" bash -c "echo 1000000000 | $1 > /dev/null"
}

function correctness_test()
{
    echo 104730 | $1 > res
    diff ../primes_lesser_than_104730 res
    if [ $? != 0 ]
    then
        echo !!! Error
    else
        echo Ok
    fi
}

echo "=============== O0 speed test =================="
speed_test ./slow.out

echo "=============== O3 speed test =================="
speed_test ./fast.out

echo "=============== O0 correctness test =================="
correctness_test ./slow.out

echo "=============== O3 correctness test =================="
correctness_test ./fast.out

# clear temp files
rm *.out res
