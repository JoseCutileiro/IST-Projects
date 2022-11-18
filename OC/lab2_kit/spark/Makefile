TARGETS = spark
CFLAGS =  -lrt

all: $(TARGETS)

cm1: cm1.c
	$(CC) $(CFLAGS) spark.c -o $(TARGETS)

clean:
	rm -f $(TARGETS) *.o *.stderr *.stdout core *~
	rm *.out *.dat
	touch spark_plot.dat
