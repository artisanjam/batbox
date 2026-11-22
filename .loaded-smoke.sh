#!/bin/bash
# loaded resume-smoke batch: driver args = <binary> <runs>
bin="$1"; runs="$2"
spin=()
for i in $(seq $(( $(nproc) + 4 ))); do
  while :; do :; done & spin+=($!)
done
trap 'kill ${spin[@]} 2>/dev/null' EXIT
fail=0
for i in $(seq "$runs"); do
  if timeout 95 python3 checks/indigenous_resume_smoke.py "$bin" >/tmp/smoke-run-$i.log 2>&1; then
    echo "run $i: PASS"
  else
    echo "run $i: FAIL (exit $?)"
    fail=$((fail+1))
    grep -m2 -E "Error|ERROR|AddressSanitizer|SEGV|BUS|logic_error|bad_" /tmp/smoke-run-$i.log | head -4
  fi
done
echo "failures: $fail/$runs"
