run_integration_tests()
{
    test_file_suite
}

test_file_suite()
{
    hint 'integrations/file'

    pass '`1` ("[o]->" "/tmp/file.txt")' '?'
    pass '("[o]<-" "/tmp/file.txt" "created")' '?'
    pass '`2` ("[o]->" "/tmp/file.txt")' '"created"'
    pass '("[o]<-" "/tmp/file.txt" "updated")' '?'
    pass '`3` ("[o]->" "/tmp/file.txt")' '"updated"'
    pass '("[o]--" "/tmp/file.txt")' '?'
    pass '`4` ("[o]->" "/tmp/file.txt")' '?'
    pass '("x<-" "before" ("[o]->" "/tmp/file.txt"))
    ("[o]<-" "/tmp/file.txt" "temporary")
    ("x<-" "during" ("[o]->" "/tmp/file.txt"))
    ("[o]--" "/tmp/file.txt")
    ("x<-" "after" ("[o]->" "/tmp/file.txt"))
    [("x->" "before") ("x->" "during") ("x->" "after")]' '[? "temporary" ?]'
}
