pass()
{
    if [ "$SUITE" = '' -o "$SUITE" = "$hint" ]
    then
        if [ "$TEST" = '' -o "$TEST" = 'unit' ]
        then
            run_test "$1" "$2" 0
            progress
        fi

        if [ "$TEST" = '' -o "$TEST" = 'batch' ]
        then
            run_batch_test "$1"
            progress
        fi

        if [ "$TEST" = '' -o "$TEST" = 'file' ]
        then
            run_file_test "$1" "$2" 0
            progress
        fi

        if [ "$TEST" = '' -o "$TEST" = 'interactive' ]
        then
            run_interactive_test "$1" "$2" 0
            progress
        fi

        if [ "$TEST" = '' -o "$TEST" = 'memory' ]
        then
            run_memory_test "$1"
            progress
        fi
    fi
}

fail()
{
    if [ "$SUITE" = '' -o "$SUITE" = "$hint" ]
    then
        if [ "$TEST" = '' -o "$TEST" = 'unit' ]
        then
            run_test "$1" "$2" 1
            progress
        fi

        if [ "$TEST" = '' -o "$TEST" = 'file' ]
        then
            run_file_test "$1" "$2" 1
            progress
        fi

        if [ "$TEST" = '' -o "$TEST" = 'interactive' ]
        then
            run_interactive_test "$1" "$2" 1
            progress
        fi

        if [ "$TEST" = '' -o "$TEST" = 'memory' ]
        then
            run_memory_test "$1"
            progress
        fi
    fi
}

conclude()
{
    end_seconds=`current_seconds`
    total_seconds=$((end_seconds-start_seconds))

    clear
    printf '%d tests run. Took %d seconds.\n' $count $total_seconds
    count=0
}

progress()
{
    printf '\033[2K\015...%s@%d' "$hint" $count
}

current_seconds()
{
    date +%s
}

if [ -z $start_seconds ]
then
    start_seconds=`current_seconds`
fi
