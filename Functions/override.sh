pass()
{
    run_test "$1" "$2" 0
    run_batch_test "$1"
    run_file_test "$1" "$2" 0
    run_interactive_test "$1" "$2" 0
    run_memory_test "$1"

    progress
}

fail()
{
    run_test "$1" "$2" 1
    run_file_test "$1" "$2" 1
    run_interactive_test "$1" "$2" 1
    run_memory_test "$1"

    progress
}

conclude()
{
    printf '\n'
    printf '%d tests run.\n' $count
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
