#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define ARR_SIZE (256 * 1024 * 1024)
#define CACHE_SIZE (6 * 1024 * 1024) // This is size of cache

typedef struct
{
    double val;
} Value;

static int A = 10; // Some coefficient
static int B = 20; // Some coefficient
static int C = 30; // Some coefficient
static int D = 40; // Some coefficient
static int E = 50; // Some coefficient

static Value * Data; // Array with values to be counted

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
static Value ** createDataArray(void)
{
    Value   ** res; /* Array of pointers to data */

    res = malloc(ARR_SIZE * sizeof(Value *));

    Data = malloc(ARR_SIZE * sizeof(Value));

    /* Initialization of data */
    srand(time(NULL));
    for(int i = 0; i < ARR_SIZE; i++)
    {
        Data[i].val = 1.0 / rand();
    }

    /* Setting pointers to random data elemnts */
    srand(time(NULL));
    for(int i = 0; i < ARR_SIZE; i++)
    {
        res[i] = &(Data[rand() % ARR_SIZE]);
    }

    return res;
}

// Deleting our array
static void deleteDataArray(Value ** data)
{
    free(Data);
    free(data);
}

double simpleSumm(Value ** data)
{
    double res;

    res = 0;
    for(int i = 0; i < ARR_SIZE; i++)
    {
        res += data[i]->val * A * B + C - D * E;
    }

    return res;
}

double prefetchSumm(Value ** data)
{
    double res;

    res = 0;
    for(int i = 0; i < ARR_SIZE; i++)
    {
        const int interval = 17;

        __builtin_prefetch(&(data[i + interval]->val), 0, 0);
        res += data[i]->val * A * B + C - D * E;
    }

    return res;
}

int main(void)
{
    Value ** data;
    double start, finish, res;

    data = createDataArray();

#ifndef PREF
    // The branch with no prefetch
    poisonCache();
    printf("Simple start\n");
    start = getTimeInSeconds();
    res = simpleSumm(data);
    finish = getTimeInSeconds();
    printf("Simple seconds: %f\n", finish - start);
#else
    // The branch with regular prefetch
    poisonCache();
    printf("Prefetch start\n");
    start = getTimeInSeconds();
    res = prefetchSumm(data);
    finish = getTimeInSeconds();
    printf("Prefetch seconds: %f\n", finish - start);
#endif // PREF

    deleteDataArray(data);

    return res;
}

