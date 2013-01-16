
(* Function sowing the array a of boolean from 2nd element to the end of array
 * and sets element with not a prime index to `false'. In the end of an algorythm
 * only elements with prime indices will be `true'. *)
let sowing = fun a max ->
	(* Walks throu the array `a' and sets dividents of `i' to false *)
	let rec sowing_tail = fun a i step max ->
		if i < max then
			(Array.set a i false;
			sowing_tail a (i + step) step max)
	in
	(* search first `true' element starting from `i' *)
	let rec sowing_head = fun a i max ->
		if i * i < max then
			(if (Array.get a i) = true then
				sowing_tail a (i + i) i max;								(* if number is prime then delete all it's dividents *)
			sowing_head a (i + 1) max		(* if not - just continue *)
			)
	in
	(* start counting and return prime number quantity *)
	sowing_head a 2 max
;;

(*let print_prime_numbers = fun a ->
	let rec print_prime_number = fun a i max ->
		if (Array.get a i) = true then
		Printf.printf "%d %!" i;
		if i < max then print_prime_number a (i+1) max
		else Printf.printf "\n%!";
	in
	print_prime_number a 0 ((Array.length a) - 1)
;;*)

let prime_num_array_to_list = fun a ->
	let rec prime_num_array_to_list_internal = fun a i l ->
		if Array.length a == i then
			l
		else
			if (Array.get a i) = true then
				prime_num_array_to_list_internal a (i + 1) (l @ [i])
			else
				prime_num_array_to_list_internal a (i + 1) l
	in
	prime_num_array_to_list_internal a 2 []
;;

(* Function takes a number, wich is the left border for searching prime numbers
 * and returns a list of prime numbers
 * *)
let sieve_of_eratosthenes = fun x ->
	let a = Array.make (read_int() + 1) true		(* `+ 1' because it's easy when element index is equal to real number. So we have a[0] -> 0, a[1] -> 1 *)
	in
	Array.set a 0 false;		(* we know, it's not prime *)
	Array.set a 1 false;		(* we know, it's not prime *)
	sowing a (Array.length a);
	prime_num_array_to_list a;
;;

let l = sieve_of_eratosthenes 100
in
List.iter (function x -> Printf.printf "%d " x) l;
Printf.printf "\n";
;;