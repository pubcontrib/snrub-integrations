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
            run_batch_test "$1"
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

    case=$((case + 1))
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

    case=$((case + 1))
    progress
}

conclude()
{
    end_seconds=`current_seconds`
    total_seconds=$((end_seconds-start_seconds))

    printf '\033[2K\015' 1>&2
    printf '%d tests run. Took %d seconds.\n' $count $total_seconds
    count=0
}

progress()
{
    percent=`printf "scale=0; $case*100/$CASES\n" | bc`
    capacity=16
    filled=`printf "scale=0; $case*$capacity/$CASES\n" | bc`
    remaining=$((capacity - filled))

    printf '\033[2K\015[' 1>&2

    while [ "$filled" -gt 0 ]
    do
        printf '=' 1>&2
        filled=$((filled - 1))
    done

    while [ "$remaining" -gt 0 ]
    do
        printf ' ' 1>&2
        remaining=$((remaining - 1))
    done

    printf ']  %s%%' "$percent" 1>&2
}

current_seconds()
{
    date +%s
}

if [ -z $start_seconds ]
then
    start_seconds=`current_seconds`
fi

if [ -z $case ]
then
    case=0
fi
