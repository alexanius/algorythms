#include "prime_numbers.h"

/**
 * @file sieve_of_sundaram.cpp
 * @brief evaluation of prime numbers with sieve of sundaram algorytm
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

IntList sieveOfSundaram(unsigned int max)
{
	unsigned int N = (max) / 2;		// because algorythm search numbers in segment [1, 2 * N + 1]
	auto countCur = [](int i, int j) {return i + j + 2 * i * j;};

	std::vector<bool> numbers(N, true);
	numbers[0] = false;								// it's not prime

	// here we execute the sieve process
	for(unsigned int i = 1,
					 j = 1,
					 cur = 4; // countCur(1, 1) == 4
		cur <= N;
		i++, j = i, cur = countCur(i, j))
		for( j = i; cur <= N; j++, cur = countCur(i, j))
			numbers[cur] = false;	// delete prime number delimiters

	// let's count result
	IntList res(new std::list<int>);		// result vector

	res->push_back(2);						// this should be set separatively
	for( unsigned int i = 1; i < N; i++)
		if( numbers[i] )
			res->push_back(i * 2 + 1);

	return std::move(res);
}

}
