(**
main file for execution of sieve of eratosthenes algorythm
 *)

let l = Sieve_of_eratosthenes.sieve_of_eratosthenes (read_int())
in
List.iter (function x -> Printf.printf "%d " x) l;
Printf.printf "\n";
;;
