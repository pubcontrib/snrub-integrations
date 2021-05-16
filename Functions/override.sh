pass()
{
    run_test "$1" "$2" 0
    progress

    run_batch_test "$1"
    progress

    run_file_test "$1" "$2" 0
    progress

    run_interactive_test "$1" "$2" 0
    progress

    run_memory_test "$1"
    progress
}

fail()
{
    run_test "$1" "$2" 1
    progress

    run_file_test "$1" "$2" 1
    progress

    run_interactive_test "$1" "$2" 1
    progress

    run_memory_test "$1"
    progress
}

conclude()
{
    end_seconds=`current_seconds`
    total_seconds=$((end_seconds-start_seconds))

    clear
    printf '%d tests run. Took %d seconds.' $count $total_seconds
    count=0
}

clear()
{
    printf '\033[2K' # Clear entire line
    printf '\015' # Carriage return
}

progress()
{
    clear
    printf "[%d in %s]" $count "$hint"
}

current_seconds()
{
    date +%s
}

if [ -z $start_seconds ]
then
    start_seconds=`current_seconds`
fi
