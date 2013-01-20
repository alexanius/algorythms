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
# @version 0.01.3

# $1 - testing mode name
# $2 - maximal number
# $3 - executable to test
#
# this function runs single test and prints resource usage
function single_test()
{
    a=$((/usr/bin/time -f "%e %M" bash -c "echo $2 | $3 > /dev/null") 2>&1 | tr -d '\n')
    printf "%b %b %b %b\n" $1 $2 $a
}

# $1 - executable for test
# $2 - testing mode name
# this tests the execution time and used memory of a program
function speed_test()
{
    echo "Mode Number Time Mem "
    single_test $2 "1000" $1
    single_test $2 "10000" $1
    single_test $2 "100000" $1
    single_test $2 "1000000" $1
    single_test $2 "10000000" $1
    single_test $2 "100000000" $1
    single_test $2 "1000000000" $1
}

# $1 is the name of alorythm
#
# this tests the correcntess of result for numbers lesser than 104730
function correctness_test()
{
    printf "Correctness test $1: "
    echo 104730 | $1 > res
    diff ../primes_lesser_than_104730 res > /dev/null
    if [ $? != 0 ]
    then
        printf "error\n"
        exit
    else
        printf "ok\n"
        rm res
    fi
}

# runs all tests
function run_tests()
{
    correctness_test ./slow.out "-O0"
    speed_test ./slow.out "-O0"

    correctness_test ./fast.out "-O3"
    speed_test ./fast.out "-O3"

    # clear temp files
    rm *.out
}

# $1 - name of compiler mode
# $2 - oprimisation keys
# $3 - definitions
# $4 - source files
# $5 - executable name
#
# Runs compilation of executable and exits if it has failed
function compile()
{
    printf "compiling $1: "
    g++ -std=c++0x -Wall -pedantic -Werror $2 $3 $4 -o $5
    if [ $? != 0 ]
    then
        printf "error\n"
        exit
    else
        printf "ok\n"
    fi
}

echo "Sieve of Eratosthenes"

# generate -O0 executable
compile "-O0" "-O0" "-D SIEVE_OF_ERATOSTHENES" \
"main.cpp sieve_of_eratosthenes.cpp" "slow.out"

# generate -O3 executable
compile "-O3" "-O3"  "-D SIEVE_OF_ERATOSTHENES" \
"main.cpp sieve_of_eratosthenes.cpp" "fast.out"

run_tests

echo "Sieve of Sundaram"

# generate -O0 executable
compile "-O0" "-O0" "-D SIEVE_OF_SUNDARAM" \
"main.cpp sieve_of_sundaram.cpp" -o "slow.out"
# geterate -O3 executable
compile "-O3" "-O3"  "-D SIEVE_OF_SUNDARAM" \
"main.cpp sieve_of_sundaram.cpp" -o "fast.out"

run_tests
