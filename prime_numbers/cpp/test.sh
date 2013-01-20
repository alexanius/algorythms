#!/bin/bash

# This is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.

# This is file for testing speed and correctness of C++ program
#
# You should have GNU version of `time' util. On my system you can install it
# with command:
#
# $ emerge sys-process/time
#
#
# @author alexanius
# @version 0.01.2

# this tests the execution time and used memory of a program
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

# this tests the correcntess of result for numbers lesser than 104730
function correctness_test()
{
    echo 104730 | $1 > res
    diff ../primes_lesser_than_104730 res > /dev/null
    if [ $? != 0 ]
    then
        echo !!! Error
    else
        echo Ok
    fi
}

function run_tests()
{
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
}

echo "! SIEVE OF ERATOSTHENES !"
# geterate -O0 executable
g++ -std=c++0x -Wall -pedantic -Werror -O0 \
-D SIEVE_OF_ERATOSTHENES \
main.cpp sieve_of_eratosthenes.cpp -o slow.out
# geterate -O3 executable
g++ -std=c++0x -Wall -pedantic -Werror -O3 \
-D SIEVE_OF_ERATOSTHENES \
main.cpp sieve_of_eratosthenes.cpp -o fast.out

run_tests

echo "! SIEVE OF SUNDARAM !"
# geterate -O0 executable
g++ -std=c++0x -Wall -pedantic -Werror -O0 \
-D SIEVE_OF_SUNDARAM \
main.cpp sieve_of_sundaram.cpp -o slow.out
# geterate -O3 executable
g++ -std=c++0x -Wall -pedantic -Werror -O3 \
-D SIEVE_OF_SUNDARAM \
main.cpp sieve_of_sundaram.cpp -o fast.out

run_tests
