#include <papi.h>
#include <stdint.h> // int16_t
#include <stdio.h>
#include <stdlib.h> // exit()
#include <string.h> // memset()

#define N 512

void handle_error(char *outstring);
void transpose(int16_t m[N][N], int16_t res[N][N]);

void setup(int16_t m1[N][N], int16_t m2[N][N], int16_t m3[N][N]) {
    int16_t tmp[N][N];
    memset(m3, 0, sizeof(int16_t) * N * N);
    for (size_t i = 0; i < N; ++i) {
        for (size_t j = 0; j < N; ++j) {
            m1[i][j] = (i + j) % 8 + 1;
            tmp[i][j] = (N - i + j) % 8 + 1;
        }
    }

    /************************************/
    /*      MATRIX TRANSPOSITION        */
    /************************************/

    transpose(tmp, m2);
}

void transpose(int16_t m[N][N], int16_t res[N][N]) {
    for (size_t i = 0; i < N; ++i) {
        for (size_t j = 0; j < N; ++j) {
            res[i][j] = m[j][i];
        }
    }
}

void multiply_matrices(int16_t const factor1[N][N], int16_t const factor2[N][N],
                       int16_t res[N][N]) {
    for (size_t i = 0; i < N; ++i) {
        for (size_t j = 0; j < N; ++j) {
            for (size_t k = 0; k < N; ++k) {
                res[i][j] += factor1[i][k] * factor2[j][k];
            }
        }
    }
}

int main() {
    int16_t mul1[N][N];
    int16_t mul2[N][N];
    int16_t res[N][N];

    setup(mul1, mul2, res);

    /************************************/

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
    /* Add load instructions to the Event Set */
    if (PAPI_add_event(EventSet, PAPI_LD_INS) != PAPI_OK) {
        handle_error("add_event");
    }
    /* Add store instructions to the Event Set */
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
    long long const start_cycles = PAPI_get_real_cyc();

    /* Gets the starting time in microseconds */
    long long const start_usec = PAPI_get_real_usec();

    multiply_matrices(mul1, mul2, res);

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
