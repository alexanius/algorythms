(**
main file for execution of sieve of eratosthenes algorythm

This is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 3, or (at your option) any later
version.

@version 0.01
@author alexanius
 *)

let l = Sieve_of_eratosthenes.sieve_of_eratosthenes (read_int())
in
List.iter (function x -> Printf.printf "%d\n" x) l
;;
