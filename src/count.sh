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
    cases=$((cases + 1))
}
