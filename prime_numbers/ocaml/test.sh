#!/bin/bash

# This is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.

# This is file for testing speed and correctness of ocaml program
#
# You should have GNU version of `time' util. On my system you can install it
# with command:
#
# $ emerge sys-process/time
#
#
# @author alexanius
# @version 0.01.4

# $1 - testing mode name
# $2 - maximal number
# $3 - executable to test
#
# this function runs single test and prints resource usage
function single_test()
{
    a=$((/usr/bin/time -f "%e %M" bash -c "echo $2 | $3 >& /dev/null") 2>&1 | tr -d '\n')
    echo $a | grep "non-zero status" > /dev/null

    if [ $? != 1 ]
    then
        printf "%b %b - -\n" $1 $2
    else
        printf "%b %b %b %b\n" $1 $2 $a
    fi
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

# $1 - name of compiler mode
# $2 - compiler name
# $3 - executable name
# $4 - source files
# $5 - other keys
#
# Runs compilation of executable and exits if it has failed
function compile()
{
    printf "compiling $1: "
    $2 -w "+A" -warn-error "+A" $5 -o $3 $4
    if [ $? != 0 ]
    then
        printf "error\n"
        exit 1
    else
        printf "ok\n"
    fi
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
        exit 2
    else
        printf "ok\n"
        rm res
    fi
}

# runs all tests
function run_tests()
{
    correctness_test ./zinc.out "zinc"
    speed_test ./zinc.out "zinc"

    correctness_test ./opt.out "opt"
    speed_test ./opt.out "opt"

    correctness_test ./opt_unsafe.out "opt_unsafe"
    speed_test ./opt_unsafe.out "opt_unsafe"

    # clear temp files
    rm *.out *.cmi *.cmo *.cmx *.o
}

# generate Zinc executable
compile "zinc" "ocamlc" "zinc.out" "sieve_of_eratosthenes.ml sieve_of_eratosthenes_main.ml" ""
# generate native executable
compile "native" "ocamlopt" "opt.out" "sieve_of_eratosthenes.ml sieve_of_eratosthenes_main.ml" ""
# generate native unsafe executable
compile "unsafe" "ocamlopt" "opt_unsafe.out" "sieve_of_eratosthenes.ml sieve_of_eratosthenes_main.ml" "-unsafe"

run_tests
