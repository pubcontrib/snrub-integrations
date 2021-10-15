introduce()
{
    cases=0
}

conclude()
{
    printf '%d' $cases
}

run_test()
{
    cases=`expr $cases + 1`
}
