hint='unset'

hint()
{
    hint=$1
}

pass()
{
    if [ "$SUITE" = '' -o "$SUITE" = "$hint" ]
    then
        if [ "$TEST" = '' -o "$TEST" = 'unit' ]
        then
            run_test "$1" "$2" 0
        fi

        if [ "$TEST" = '' -o "$TEST" = 'batch' ]
        then
            append_batch_test "$1"
        fi

        if [ "$TEST" = '' -o "$TEST" = 'file' ]
        then
            run_file_test "$1" "$2" 0
        fi

        if [ "$TEST" = '' -o "$TEST" = 'interactive' ]
        then
            run_interactive_test "$1" "$2" 0
        fi

        if [ "$TEST" = '' -o "$TEST" = 'memory' ]
        then
            run_memory_test "$1"
        fi
    fi

    case=`expr $case + 1`
    progress
}

fail()
{
    if [ "$SUITE" = '' -o "$SUITE" = "$hint" ]
    then
        if [ "$TEST" = '' -o "$TEST" = 'unit' ]
        then
            run_test "$1" "$2" 1
        fi

        if [ "$TEST" = '' -o "$TEST" = 'file' ]
        then
            run_file_test "$1" "$2" 1
        fi

        if [ "$TEST" = '' -o "$TEST" = 'interactive' ]
        then
            run_interactive_test "$1" "$2" 1
        fi

        if [ "$TEST" = '' -o "$TEST" = 'memory' ]
        then
            run_memory_test "$1"
        fi
    fi

    case=`expr $case + 1`
    progress
}

introduce()
{
    start_seconds=`current_seconds`
    case=0
    count=0
}

conclude()
{
    run_integration_tests

    if [ "$TEST" = '' -o "$TEST" = 'batch' ]
    then
        run_batch_test
    fi

    end_seconds=`current_seconds`
    total_seconds=`expr $end_seconds - $start_seconds`

    printf '\033[2K\015' 1>&2
    printf '%d tests run. Took %d seconds.\n' $count $total_seconds
}

run_test()
{
    text=$1
    expected_output=$2
    expected_code=$3

    actual_output=`$PROGRAM -t "$text"`
    actual_code=$?

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

    count=`expr $count + 1`
}

run_batch_test()
{
    match='"done"'
    buffer="$buffer $match"
    run_test "$buffer" "$match" 0
}

run_file_test()
{
    text=$1
    expected_output=$2
    expected_code=$3

    umask 077
    file=`mktemp`

    if [ -s "$file" ]
    then
        printf '\033[2K\015' 1>&2
        printf '[ERROR] Temporary file is non-empty.\n' 1>&2
        printf 'Hint: %s\n' "$hint" 1>&2
        printf 'Source: %s\n' "$text" 1>&2
        exit 1
    fi

    printf '%s' "$text" > "$file"
    actual_output=`$PROGRAM -f "$file"`
    actual_code=$?
    rm "$file"

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

    count=`expr $count + 1`
}

run_interactive_test()
{
    text=$1
    expected_output=$2
    expected_code=$3

    newline_count=`printf '%s' "$text" | wc -l`

    if [ $newline_count -gt 0 ]
    then
        return 0
    fi

    actual_output=`printf '%s\n' "$text" | $PROGRAM -i`
    actual_code=$?

    if [ $expected_code -eq 0 ]
    then
        expected_output=`printf '> %s\n> \n' "$expected_output"`
    else
        expected_output=`printf '> %s\n' "$expected_output"`
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

    count=`expr $count + 1`
}

run_memory_test()
{
    text=$1

    output=`valgrind --leak-check=full --error-exitcode=64 $PROGRAM -t "$text" 2>&1`
    code=$?

    if [ $code -ne 0 -a $code -ne 1 ]
    then
        printf '\033[2K\015' 1>&2
        printf '[ERROR] Test case failed memory leak test.\n' 1>&2
        printf 'Hint: %s\n' "$hint" 1>&2
        printf 'Source: %s\n' "$text" 1>&2
        printf 'Log: %s\n' "$output" 1>&2
        exit 1
    fi

    count=`expr $count + 1`
}

append_batch_test()
{
    buffer="$buffer $1"
}

progress()
{
    percent=`printf 'scale=0; %d*100/%d\n' "$case" "$CASES" | bc`

    if [ "$percent" != "$last_percent" ]
    then
        capacity=16
        filled=`printf 'scale=0; %d*%d/%d\n' "$case" "$capacity" "$CASES" | bc`
        remaining=`expr $capacity - $filled`

        printf '\033[2K\015[' 1>&2

        while [ "$filled" -gt 0 ]
        do
            printf '=' 1>&2
            filled=`expr $filled - 1`
        done

        while [ "$remaining" -gt 0 ]
        do
            printf ' ' 1>&2
            remaining=`expr $remaining - 1`
        done

        printf ']  %s%%' "$percent" 1>&2

        last_percent=$percent
    fi
}

current_seconds()
{
    date +%s
}
