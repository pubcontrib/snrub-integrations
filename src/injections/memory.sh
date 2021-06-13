run_memory_test()
{
    text=$1

    output=`valgrind --leak-check=full --error-exitcode=64 $PROGRAM -t "$text" 2>&1`
    code=$?

    if [ $code -ne 0 -a $code -ne 1 ]
    then
        printf '[ERROR] Test case failed memory leak test.\n' 1>&2
        printf 'Hint: %s\n' "$hint" 1>&2
        printf 'Source: %s\n' "$text" 1>&2
        printf 'Log: %s\n' "$output" 1>&2
        exit 1
    fi

    count=$((count + 1))
}
