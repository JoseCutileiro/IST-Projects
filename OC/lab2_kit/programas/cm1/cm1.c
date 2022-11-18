#include <errno.h>
#include <papi.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h> // exit()
#include <string.h>

#define CACHE_MIN (8 * 1024)
#define CACHE_MAX (64 * 1024)
#define N_REPETITIONS (200)

void handle_error(char *outstring);

int main() {

    uint8_t *array = calloc(CACHE_MAX, sizeof(uint8_t));
    if (array == NULL) {
        fprintf(stderr, "[ERR]: failed to allocate %d B: %s\n", CACHE_MAX,
                strerror(errno));
        exit(EXIT_FAILURE);
    }

    /* Initialize the PAPI library */
    int retval = PAPI_library_init(PAPI_VER_CURRENT);
    if (retval != PAPI_VER_CURRENT) {
        fprintf(stderr, "PAPI library init error!\n");
        exit(EXIT_FAILURE);
    }

    /* Create the Event Set */
    int EventSet = PAPI_NULL;
    if (PAPI_create_eventset(&EventSet) != PAPI_OK) {
        handle_error("create_eventset");
    }

    /* Add L1 data cache misses to our Event Set */
    if (PAPI_add_event(EventSet, PAPI_L1_DCM) != PAPI_OK) {
        handle_error("add_event");
    }

    for (size_t cache_size = CACHE_MIN; cache_size <= CACHE_MAX;
         cache_size = cache_size * 2) {
        for (size_t stride = 1; stride <= cache_size / 2; stride = stride * 2) {
            size_t const limit = cache_size - stride + 1;

            /* Reset the counting events in the Event Set */
            if (PAPI_reset(EventSet) != PAPI_OK) {
                handle_error("reset");
            }

            /* Read the counting of events in the Event Set */
            long long values[2];
            if (PAPI_read(EventSet, values) != PAPI_OK) {
                handle_error("read");
            }

            /* Start counting events in the Event Set */
            if (PAPI_start(EventSet) != PAPI_OK) {
                handle_error("start");
            }

            /* Gets the starting time in clock cycles */
            long long const start_cycles = PAPI_get_real_cyc();

            /* Gets the starting time in microseconds */
            long long const start_usec = PAPI_get_real_usec();

            /************************************/
            size_t n_iterations = 0;
            for (size_t repeat = 0; repeat <= N_REPETITIONS * stride; repeat++) {
                for (size_t index = 0; index < limit; index += stride, n_iterations++) {
                    array[index] = array[index] + 1;
                }
            }
            /************************************/

            /* Gets the ending time in clock cycles */
            long long const end_cycles = PAPI_get_real_cyc();

            /* Gets the ending time in microseconds */
            long long const end_usec = PAPI_get_real_usec();

            /* Stop the counting of events in the Event Set */
            if (PAPI_stop(EventSet, values) != PAPI_OK) {
                handle_error("stop");
            }

            /************************************/
            float const avg_misses = (float)(values[0]) / n_iterations;
            float const avg_time = (float)(end_usec - start_usec) / n_iterations;
            float const avg_cycles = (float)(end_cycles - start_cycles) / n_iterations;
            fprintf(stdout,
                    "cache_size=%zu\tstride=%zu\tavg_misses=%f\tavg_time=%f\n",
                    cache_size, stride, avg_misses, avg_time);
        }
    }

    return 0;
}

void handle_error(char *outstring) {
    printf("Error in PAPI function call %s\n", outstring);
    PAPI_perror("PAPI Error");
    exit(EXIT_FAILURE);
}
