find tests/ -executable -type f -print0 |
  while IFS= read -r -d '' line; do
    echo "==> Running: $line"
    if ./"$line" | grep "Successful"; then
      echo "PASSED"
    else
      printf "FAILED \n"
      echo "================== RUN LOG =================="
      ./"$line"
      exit 1
    fi
  done
