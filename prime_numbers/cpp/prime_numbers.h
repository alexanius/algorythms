#ifndef PRIME_NUMBERS_H
#define PRIME_NUMBERS_H

/**
 * @file prime_numbers.h
 * @brief this is header file for algorythms, calculating prime numbers
 */

#include <list>
#include <memory>

namespace primeNumbers
{

typedef std::unique_ptr<std::list<int>> IntList;

IntList sieveOfEratosthenes(unsigned int max);
IntList sieveOfSundaram(unsigned int max);

}

#endif // PRIME_NUMBERS_H
