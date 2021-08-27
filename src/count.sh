conclude()
{
    printf '%d' $cases
}

run_test()
{
    cases=$((cases + 1))
}

if [ -z $cases ]
then
    cases=0
fi
