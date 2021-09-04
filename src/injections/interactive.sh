run_interactive_test()
{
    text=$1
    expected_output=$2
    expected_code=$3

    newline_count=`printf "%s" "$text" | wc -l`

    if [ $newline_count -gt 0 ]
    then
        return 0
    fi

    actual_output=`printf "%s\n" "$text" | $PROGRAM -i`
    actual_code=$?

    if [ $expected_code -eq 0 ]
    then
        expected_output=`printf "> %s\n> \n" "$expected_output"`
    else
        expected_output=`printf "> %s\n" "$expected_output"`
    fi

    if [ $actual_code != $expected_code ]
    then
        printf '\033[2K\015' 1>&2
        printf '[ERROR] Test case returned an unexpected exit code.\n' 1>&2
        printf 'Hint: %s\n' "$hint" 1>&2
        printf 'Source: %s\n' "$text" 1>&2
        printf 'Expected: %d\n' $expected_code 1>&2
        printf 'Actual: %d\n' $actual_code 1>&2
        exit 1
    fi

    if [ "$actual_output" != "$expected_output" ]
    then
        printf '\033[2K\015' 1>&2
        printf '[ERROR] Test case returned an unexpected stdout.\n' 1>&2
        printf 'Hint: %s\n' "$hint" 1>&2
        printf 'Source: %s\n' "$text" 1>&2
        printf 'Expected: %s\n' "$expected_output" 1>&2
        printf 'Actual: %s\n' "$actual_output" 1>&2
        exit 1
    fi

    count=$((count + 1))
}
