introduce()
{
    cases=0
}

conclude()
{
    run_integration_tests

    printf '%d' $cases
}

run_test()
{
    cases=`expr $cases + 1`
}
