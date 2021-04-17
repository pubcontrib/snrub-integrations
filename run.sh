#!/bin/sh
integration_path=`dirname $0`
repo_path=$1

if [ ! -d "$integration_path" ]
then
    printf "[ERROR] No integration path found."
    exit 1
fi

if [ ! -d "$repo_path" ]
then
    printf "[ERROR] No repo path found.\n"
    exit 1
fi

integration_path=`readlink -f "$integration_path"`
repo_path=`readlink -f "$repo_path"`

# Copy integration test functions to the test project
cd "$integration_path/Functions"
destination_file="$repo_path/test/assert.sh"
functions=`ls`

for function in $functions
do
    name=`basename $function`
    cat "$function" >> "$destination_file"
done

# Run the test suite now that integration tests are merged in
cd "$repo_path"
make > /dev/null 2>&1
make check 2>&1
status=$?

# Reset the state of the source repo
make clean > /dev/null 2>&1
git reset --hard HEAD > /dev/null 2>&1

# Print the results
printf "%s\n" "$output"
exit $status
