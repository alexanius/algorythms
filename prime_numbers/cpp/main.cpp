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

	auto l(primeNumbers::sieveOfEratosthenes(max));

	for( int i : *l)
		std::cout << i << std::endl;
}
