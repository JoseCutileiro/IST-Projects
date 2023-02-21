#define _GNU_SOURCE
#include <arpa/inet.h>
#include <assert.h>
#include <dlfcn.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/file.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#define PASS_THROUGH(fn, ...)                                                  \
  (((__typeof__(fn) *)dlsym(RTLD_NEXT, #fn))(__VA_ARGS__))

ssize_t sendto(int socket, const void *message, size_t length, int flags,
               const struct sockaddr *dst_addr, socklen_t dst_length) {
  const char *packet_log = getenv("PACKET_LOG");

  const char *delay_str = getenv("SEND_DELAY");
  if (delay_str) {
    usleep(atoi(delay_str) * 1000);
  }

  static char *drop_pattern = NULL;
  if (!drop_pattern) {
    drop_pattern = getenv("DROP_PATTERN");
    if (!drop_pattern) {
      drop_pattern = "";
    }
  }

  FILE *log = fopen(packet_log, "a");
  assert(log && "Unable to open packet log file.");

  ssize_t result;
  if (drop_pattern[0] != '1') {
    result = PASS_THROUGH(sendto, socket, message, length, flags, dst_addr,
                          dst_length);
  } else {
    result = length;
  }

  struct timespec tp;
  clock_gettime(CLOCK_MONOTONIC, &tp);

  struct sockaddr_in bind_addr;
  socklen_t bind_len = sizeof(bind_addr);
  assert(getsockname(socket, &bind_addr, &bind_len) == 0);

  char bind_addr_str[INET_ADDRSTRLEN];
  inet_ntop(AF_INET, &bind_addr.sin_addr, bind_addr_str, INET_ADDRSTRLEN);

  char dst_addr_str[INET_ADDRSTRLEN];
  inet_ntop(AF_INET, &(((struct sockaddr_in *)dst_addr)->sin_addr),
            dst_addr_str, INET_ADDRSTRLEN);

  fprintf(log, "%ld.%ld %s %d %s %s %d", tp.tv_sec, tp.tv_nsec, bind_addr_str,
          ntohs(bind_addr.sin_port), drop_pattern[0] != '1' ? "=>" : "-x",
          dst_addr_str, ntohs(((struct sockaddr_in *)dst_addr)->sin_port));

  for (int i = 0; i < length; i++) {
    fprintf(log, " %02X", ((uint8_t *)message)[i]);
  }
  fprintf(log, "\n");
  fflush(log);

  fclose(log);

  if (drop_pattern[0]) {
    drop_pattern++;
  }

  return result;
}

ssize_t recvfrom(int socket, void *message, size_t length, int flags,
                 struct sockaddr *src_addr, socklen_t *src_length) {
  const char *packet_log = getenv("PACKET_LOG");

  ssize_t result = PASS_THROUGH(recvfrom, socket, message, length, flags,
                                src_addr, src_length);

  FILE *log = fopen(packet_log, "a");
  assert(log && "Unable to open packet log file.");

  struct timespec tp;
  clock_gettime(CLOCK_MONOTONIC, &tp);

  struct sockaddr_in bind_addr;
  socklen_t bind_len = sizeof(bind_addr);
  assert(getsockname(socket, &bind_addr, &bind_len) == 0);

  char bind_addr_str[INET_ADDRSTRLEN];
  inet_ntop(AF_INET, &bind_addr.sin_addr, bind_addr_str, INET_ADDRSTRLEN);

  if (result >= 0) {
    char src_addr_str[INET_ADDRSTRLEN];
    inet_ntop(AF_INET, &(((struct sockaddr_in *)src_addr)->sin_addr),
              src_addr_str, INET_ADDRSTRLEN);

    fprintf(log, "%ld.%ld %s %d <= %s %d", tp.tv_sec, tp.tv_nsec, bind_addr_str,
            ntohs(bind_addr.sin_port), src_addr_str,
            ntohs(((struct sockaddr_in *)src_addr)->sin_port));

    for (int i = 0; i < length; i++) {
      fprintf(log, " %02X", ((uint8_t *)message)[i]);
    }
    fprintf(log, "\n");
  } else {
    fprintf(log, "%ld.%ld %s %d x-\n", tp.tv_sec, tp.tv_nsec, bind_addr_str,
            ntohs(bind_addr.sin_port));
  }

  fflush(log);

  fclose(log);

  return result;
}
