#include <papi.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h> // exit()
#include <string.h>

#define N 512
#define CACHE_LINE_SIZE 1 // TODO: update this value

#define SUB_MATRIX_SIZE                                                        \
    (((CACHE_LINE_SIZE / sizeof(int16_t)) <= 0)                                \
         ? 1                                                                   \
         : (CACHE_LINE_SIZE / sizeof(int16_t)))

void handle_error(char *outstring);

void setup(int16_t m1[N][N], int16_t m2[N][N], int16_t m3[N][N]) {
    memset(m3, 0, sizeof(int16_t) * N * N);
    for (size_t i = 0; i < N; ++i) {
        for (size_t j = 0; j < N; ++j) {
            m1[i][j] = (i + j) % 8 + 1;
            m2[i][j] = (N - i + j) % 8 + 1;
        }
    }
}

void multiply_matrices_by_blocks(int16_t const factor1[N][N],
                                 int16_t const factor2[N][N],
                                 int16_t res[N][N]) {
    for (size_t i = 0; i < N; i += SUB_MATRIX_SIZE) {
        for (size_t j = 0; j < N; j += SUB_MATRIX_SIZE) {
            for (size_t k = 0; k < N; k += SUB_MATRIX_SIZE) {
                for (size_t inner_i = 0; inner_i < SUB_MATRIX_SIZE; ++inner_i) {
                    for (size_t inner_k = 0; inner_k < SUB_MATRIX_SIZE;
                         ++inner_k) {
                        for (size_t inner_j = 0; inner_j < SUB_MATRIX_SIZE;
                             ++inner_j) {
                            res[i + inner_i][j + inner_j] +=
                                factor1[i + inner_i][k + inner_k] *
                                factor2[k + inner_k][j + inner_j];
                        }
                    }
                }
            }
        }
    }
}

int main() {

    int16_t mul1[N][N] __attribute__((aligned(CACHE_LINE_SIZE)));
    int16_t mul2[N][N] __attribute__((aligned(CACHE_LINE_SIZE)));
    int16_t res[N][N] __attribute__((aligned(CACHE_LINE_SIZE)));

    setup(mul1, mul2, res);

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

    /* Add L1 data cache misses to the Event Set */
    if (PAPI_add_event(EventSet, PAPI_L1_DCM) != PAPI_OK) {
        handle_error("add_event");
    }
    /* Add load instructions completed to the Event Set */
    if (PAPI_add_event(EventSet, PAPI_LD_INS) != PAPI_OK) {
        handle_error("add_event");
    }
    /* Add store instructions completed to the Event Set */
    if (PAPI_add_event(EventSet, PAPI_SR_INS) != PAPI_OK) {
        handle_error("add_event");
    }

    /* Reset the counting events in the Event Set */
    if (PAPI_reset(EventSet) != PAPI_OK) {
        handle_error("reset");
    }

    /* Read the counting of events in the Event Set */
    long long values[3];
    if (PAPI_read(EventSet, values) != PAPI_OK) {
        handle_error("read");
    }

    fprintf(stdout, "After resetting counter 'PAPI_L1_DCM' [x10^6]: %f\n",
            (double)(values[0]) / 1000000);
    fprintf(stdout, "After resetting counter 'PAPI_LD_INS' [x10^6]: %f\n",
            (double)(values[1]) / 1000000);
    fprintf(stdout, "After resetting counter 'PAPI_SR_INS' [x10^6]: %f\n",
            (double)(values[2]) / 1000000);

    /* Start counting events in the Event Set */
    if (PAPI_start(EventSet) != PAPI_OK) {
        handle_error("start");
    }

    /* Gets the starting time in clock cycles */
    long long start_cycles = PAPI_get_real_cyc();

    /* Gets the starting time in microseconds */
    long long start_usec = PAPI_get_real_usec();

    /************************************/
    /*      MATRIX MULTIPLICATION       */
    /************************************/

    multiply_matrices_by_blocks(mul1, mul2, res);

    /************************************/

    /* Gets the ending time in clock cycles */
    long long end_cycles = PAPI_get_real_cyc();

    /* Gets the ending time in microseconds */
    long long end_usec = PAPI_get_real_usec();

    /* Stop the counting of events in the Event Set */
    if (PAPI_stop(EventSet, values) != PAPI_OK) {
        handle_error("stop");
    }

    fprintf(stdout, "After stopping counter 'PAPI_L1_DCM'  [x10^6]: %f\n",
            (double)(values[0]) / 1000000);
    fprintf(stdout, "After stopping counter 'PAPI_LD_INS'  [x10^6]: %f\n",
            (double)(values[1]) / 1000000);
    fprintf(stdout, "After stopping counter 'PAPI_SR_INS'  [x10^6]: %f\n",
            (double)(values[2]) / 1000000);

    fprintf(stdout, "Wall clock cycles [x10^6]: %f\n",
            (double)(end_cycles - start_cycles) / 1000000);
    fprintf(stdout, "Wall clock time [seconds]: %f\n",
            (double)(end_usec - start_usec) / 1000000);

    long long checksum = 0;
    for (size_t i = 0; i < N; ++i) {
        for (size_t j = 0; j < N; ++j) {
            checksum += res[i][j];
        }
    }
    fprintf(stdout, "Matrix checksum: %lld\n", checksum);

    return 0;
}

void handle_error(char *outstring) {
    fprintf(stderr, "Error in PAPI function call %s\n", outstring);
    PAPI_perror("PAPI Error");
    exit(EXIT_FAILURE);
}
