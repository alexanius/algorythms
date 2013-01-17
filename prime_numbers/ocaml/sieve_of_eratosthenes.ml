(**
evaluation of prime numbers with sieve of eratosthenes algorytm

@version 0.01
@author alexanius
 *)

(*
@param a array of bool where a[i] == true menas that a is prime
@return list of prime numbers

Convert array of numbers to list, putting there only prime numbers
*)
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

(**
@param x left bound of counting prime numbers

Count all prime numbers that are less than x
*)
let sieve_of_eratosthenes = fun x ->
	(**
	@param a array of boolean where true means prime
	@param max left bound of counting prime numbers

	Function sowing the array a of boolean from 2nd element to the end of array
	and sets element with not a prime index to `false'. In the end of an algorythm
	only elements with prime indices will be `true'.
	*)
	let sowing = fun a max ->
		(**
		@param a array of boolean where true means prime
		@param i current index
		@param step index incrementing step
		@param max left bound of counting prime numbers

		Walks through the array `a' and sets dividents of `i' to false
		*)
		let rec sowing_tail = fun a i step max ->
			if i < max then
				(Array.set a i false;
				sowing_tail a (i + step) step max)
		in
		(**
		@param a array of boolean where true means prime
		@param i current index
		@param max left bound of counting prime numbers

		search first `true' element starting from `i'
		*)
		let rec sowing_head = fun a i max ->
			if i * i < max then
				(if (Array.get a i) = true then
					sowing_tail a (i + i) i max;	(*** if number is prime then delete all it's dividents *)
				sowing_head a (i + 1) max			(*** if not - just continue *)
				)
		in
		(*** start counting and return prime number quantity *)
		sowing_head a 2 max
	in
	let a = Array.make (x + 1) true		(** `+ 1' because it's easy when element index is equal to real number. So we have a[0] -> 0, a[1] -> 1 *)
	in
	Array.set a 0 false;		(** we know, it's not prime *)
	Array.set a 1 false;		(** we know, it's not prime *)
	sowing a (Array.length a);
	prime_num_array_to_list a;
;;
