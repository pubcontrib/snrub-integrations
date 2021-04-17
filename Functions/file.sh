run_file_test()
{
    text=$1
    expected_output=$2
    expected_code=$3

    file=`mktemp`
    printf "%s\n" "$text" > "$file"
    actual_output=`$PROGRAM -f "$file"`
    actual_code=$?

    if [ $actual_code != $expected_code ]
    then
        printf "[ERROR] Test case returned an unexpected exit code.\n" 1>&2
        printf "Hint: %s\n" "$hint" 1>&2
        printf "Source: %s\n" "$text" 1>&2
        printf "Expected: %d\n" $expected_code 1>&2
        printf "Actual: %d\n" $actual_code 1>&2
        exit 1
    fi

    if [ "$actual_output" != "$expected_output" ]
    then
        printf "[ERROR] Test case returned an unexpected stdout.\n" 1>&2
        printf "Hint: %s\n" "$hint" 1>&2
        printf "Source: %s\n" "$text" 1>&2
        printf "Expected: %s\n" "$expected_output" 1>&2
        printf "Actual: %s\n" "$actual_output" 1>&2
        exit 1
    fi

    rm "$file"

    count=$((count + 1))
}
