#!/bin/bash

if [ $LPP"x" == "x" ]; then
    echo "Please set LPP environment variable"
    exit
fi

rm -fr output/
mkdir -p output/
passed=0
failed=0
for file in $(ls tests/*); do
    NAME=$(basename -s .lpp $file)
    $LPP $file | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g' > output/$NAME.txt
    diff output/$NAME.txt expected/$NAME.txt
    if [ $? -ne 0 ]; then
        echo -e "Test ${NAME}.lpp \e[31mfailed\e[0m"
        failed=$((failed + 1))
    else
        echo -e "Test ${NAME}.lpp \e[32mpassed\e[0m"
        passed=$((passed + 1))
    fi
done
total=$((failed + passed))
echo "============================="
echo -e "Total tests: $total"
echo -e "Failed: \e[31m$failed\e[0m"
echo -e "Passed: \e[32m$passed\e[0m"
echo "============================="
