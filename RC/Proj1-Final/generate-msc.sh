#!/bin/bash

set -euo pipefail

OUTPUT="$1"
shift 1

COMBINED_LOG=$(mktemp)
MSC_FILE=$(mktemp)


sort -n $@ > $COMBINED_LOG

# Compute arcskips (difference in line number between message being sent and
# received). Dump result as an awk array.
ARCSKIPS="$(awk '
  function comp_func(i1, v1, i2, v2) { return (i1 - i2); }

  BEGIN { PROCINFO["sorted_in"] = "comp_func" }

  {
    if ($4 == "=>") {
      pending[NR] = $3 " " $6;
    } else if ($4 == "<=") {
      for (pos in pending) {
        if (pending[pos] == $6 " " $3) {
          arcskips[pos] = NR - pos;
          delete pending[pos];
          break;
        }
      }
    }
  }

  END {
    for (pos in pending) {
      arcskips[pos] = NR - pos + 2;
    }
    for (pos in arcskips) {
      printf "arcskips[%d] = %d;\n", pos, arcskips[pos];
    }
  }' $COMBINED_LOG)";

# Start MSC file. List out unique entities, identified by just port number.
awk '
  BEGIN { print "msc {"; }

  {
    if (!seen[$3]) {
      printf "%sp%s [label=\"127.0.0.1:%s\"]", (NR==1 ? "  " : ", "), $3, $3;
      seen[$3]++;
    }
    if ($6 !="" && !seen[$6]) {
      printf ", p%s [label=\"127.0.0.1:%s\"]", $6, $6;
      seen[$6]++;
    }
  }
  END { print ";" }' $COMBINED_LOG > $MSC_FILE;

# Dump MSC edges.
awk "
  BEGIN { $ARCSKIPS }
  {
    if (first_time == 0) {
      first_time = \$1;
    }
    if (\$4 == \"=>\") {
      printf \"  p%s => p%s [label=\\\"t=%sms:%s\\\", arcskip=\\\"%s\\\"];\\n\", \$3, \$6, int((\$1 - first_time) * 1000), \$7 \$8 \$9 \$10, int(arcskips[NR]);
    } else if (\$4 == \"-x\") {
      printf \"  p%s -x p%s [label=\\\"t=%sms:%s\\\"];\\n\", \$3, \$6, int((\$1 - first_time) * 1000), \$7 \$8 \$9 \$10;
    } else if (\$4 == \"<=\") {
      print \"|||;\";
    } else if (\$4 == \"x-\") {
      print \"...;\";
    }
  }
  END {
    print \"  --- [label = \\\"Done\\\"];\";
    print \"  |||;\";
    print \"}\";
  }" $COMBINED_LOG >> $MSC_FILE

mscgen -Teps -o $OUTPUT -i $MSC_FILE

rm -f $COMBINED_LOG $MSC_FILE
