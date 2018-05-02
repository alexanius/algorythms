#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define ARR_SIZE (512 * 1024 * 1024) // This is number of elements of our array
#define CACHE_SIZE (6 * 1024 * 1024) // This is size of cache

static int unroll = 2; // Unroll factor
static int A = 10; // Some coefficient
static int B = 20; // Some coefficient
static int C = 30; // Some coefficient
static int D = 40; // Some coefficient
static int E = 50; // Some coefficient

// Here we make loads of the trach array to eliminate all useful lines from cache
static void poisonCache(void)
{
    static const char trash[CACHE_SIZE] = { 1 };
    volatile int summ;

    for(int i = 0; i < CACHE_SIZE; i++)
    {
        summ += trash[i];
    }
}

// Just getting current time
static double getTimeInSeconds(void)
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (double)tv.tv_sec + 1.e-6 * (double)tv.tv_usec;
}

// Create an array for measurement
static double * createDataArray(void)
{
    double * res;
    res = malloc(ARR_SIZE * sizeof(double));

    for(int i = 0; i < ARR_SIZE; i++)
    {
        res[i] = i & 255;
    }

    return res;
}

// Deleting our array
static void deleteDataArray(double * data)
{
    free(data);
}

// Here we make loads without prefetch. The loop is unrolled
// with factor 2
static double simpleSumm(const double * data)
{
    double res = 0;

    for(int i = 0; i < ARR_SIZE; i+= unroll)
    {
        res += data[i] * A * B + C - D * E;
        res += data[i + 1] * A * B + C - D * E;
    }

    return res;
}

// Here we make loads with regular prefetch. The loop is unrolled
// with factor 2
static double prefetchSumm(const double * data)
{
    double res = 0;
    int interval = 32;

    for(int i = 0; i < ARR_SIZE; i+= unroll)
    {
	__builtin_prefetch(&data[i + interval], 0, 0);
        res += data[i] * A * B + C - D * E;
        res += data[i + 1] * A * B + C - D * E;
    }

    return res;
}

int main(void)
{
    double * data;
    double start, finish;

    data = createDataArray();

#ifndef PREF
    // The branch with no prefetch
    poisonCache();
    printf("Simple start\n");
    start = getTimeInSeconds();
    simpleSumm(data);
    finish = getTimeInSeconds();
    printf("Simple seconds: %f\n", finish - start);
#else
    // The branch with regular prefetch
    poisonCache();
    printf("Prefetch start\n");
    start = getTimeInSeconds();
    prefetchSumm(data);
    finish = getTimeInSeconds();
    printf("Prefetch seconds: %f\n", finish - start);
#endif // PREF

    deleteDataArray(data);
}

