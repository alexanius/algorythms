#include "prime_numbers.h"

#include <list>
#include <iostream>

/**
 * @brief main file for execution of sieve of eratosthenes algorythm
 */

int main()
{
	unsigned int max;
	std::cin >> max;

#ifdef SIEVE_OF_ERATOSTHENES
	auto l(primeNumbers::sieveOfEratosthenes(max));
#elif SIEVE_OF_SUNDARAM
	auto l(primeNumbers::sieveOfSundaram(max));
#endif

	for( int i : *l)
		std::cout << i << std::endl;
}
