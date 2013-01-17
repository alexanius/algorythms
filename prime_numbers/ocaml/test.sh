#!/bin/bash

# This is file for testing speed and correctness of ocaml program
#
# This is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.
#
# @author alexanius

# geterate Zinc executable
ocamlc -w "+A" -warn-error "+A" -o zinc.out sieve_of_eratosthenes.ml sieve_of_eratosthenes_main.ml
# geterate native executable
ocamlopt -w "+A" -warn-error "+A" -o opt.out sieve_of_eratosthenes.ml sieve_of_eratosthenes_main.ml
# geterate native unsafe executable
ocamlopt -w "+A" -warn-error "+A" -o opt_unsafe.out sieve_of_eratosthenes.ml sieve_of_eratosthenes_main.ml

# speed test
function speed_test()
{
    echo
    echo Testing 1000
    time echo 1000 | $1 > /dev/null

    echo
    echo Testing 10.000
    time echo 10000 | $1 > /dev/null

    echo
    echo Testing 100.000
    time echo 100000 | $1 > /dev/null

    echo
    echo Testing 1.000.000
    time echo 1000000 | $1 > /dev/null

    echo
    echo Testing 2.000.000.000
    time echo 2000000000 | $1 > /dev/null
}

echo "=============== Zinc test =================="
speed_test ./zinc.out

echo "=============== Native O0 test =================="
speed_test ./opt.out

echo "=============== Native unsafe test =================="
speed_test ./opt_unsafe.out

# clear temp files
rm *.out *cmi *cmo *cmx *o
