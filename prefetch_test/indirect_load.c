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
    Value ** res;
    res = malloc(ARR_SIZE * sizeof(Value *));

    for(int i = 0; i < ARR_SIZE / 2; i+=3)
    {
        void * stub1, * stub2;

        res[ARR_SIZE - i - 1] = malloc(sizeof(Value));
	res[ARR_SIZE - i - 1]->val = ARR_SIZE - i;

	stub1 = malloc(64);

        res[i + 1] = malloc(sizeof(Value));
	res[i + 1]->val = i + 1;

	stub2 = malloc(64);

        res[ARR_SIZE - i - 3] = malloc(sizeof(Value));
	res[ARR_SIZE - i - 3]->val = ARR_SIZE - i - 3;

	free(stub1);
	free(stub2);

        res[i + 2] = malloc(sizeof(Value));
	res[i + 2]->val = i + 2;

	stub1 = malloc(64);

        res[ARR_SIZE - i - 2] = malloc(sizeof(Value));
	res[ARR_SIZE - i - 2]->val = ARR_SIZE - i - 2;

	stub2 = malloc(64);

        res[i] = malloc(sizeof(Value));
	res[i]->val = i;

	free(stub1);
	free(stub2);
    }

    return res;
}

// Deleting our array
static void deleteDataArray(Value ** data)
{
    for(int i = 0; i < ARR_SIZE; i++)
    {
        free(data[i]);
    }

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
        int interval = 24;
	__builtin_prefetch(&(data[i + interval]->val), 0, 0);
        res += data[i]->val * A * B + C - D * E;
    }

    return res;
}

int main(void)
{
    Value ** data;
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

