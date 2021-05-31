run_batch_test()
{
    text=$1

    buffer="$buffer $text"
    match='"done"'
    buffer="$buffer $match"

    run_test "$buffer" "$match" 0
}
