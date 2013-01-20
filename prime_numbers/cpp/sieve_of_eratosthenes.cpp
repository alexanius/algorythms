#include "prime_numbers.h"

/**
 * @file sieve_of_eratosthenes.cpp
 * @brief evaluation of prime numbers with sieve of eratosthenes algorytm
 *
 * This is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 3, or (at your option) any later
 * version.
 *
 * @version 0.01
 * @author alexanius
 */

#include <vector>

namespace primeNumbers
{

/**
 * @brief search all prime numbers lesser than @a max
 * @param [in] max maximal prime number
 * @returns list with prime numbers
 */

IntList sieveOfEratosthenes(unsigned int max)
{
	std::vector<bool> numbers(++max, true);
	numbers[0] = false;								// it's not prime
	numbers[1] = false;								// it's not prime

	for(unsigned int i = 2; i * i < max; i++)		// find prime number
		if( numbers[i] )
			for( unsigned int j = i + i; j < max; j += i)	// delete prime number delimiters
				numbers[j] = false;

	IntList res(new std::list<int>);		// result vector

	for( unsigned int i = 2; i < max; i++)
		if( numbers[i] )
			res->push_back(i);

	return std::move(res);
}

}
