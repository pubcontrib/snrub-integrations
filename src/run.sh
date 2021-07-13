#!/bin/sh
integration_path=`dirname $0`
repo_path=$1

if [ ! -d "$integration_path" ]
then
    printf '[ERROR] No integration path found.\n'
    exit 1
fi

if [ ! -d "$repo_path" ]
then
    printf '[ERROR] No repo path found.\n'
    exit 1
fi

integration_path=`readlink -f "$integration_path"`
repo_path=`readlink -f "$repo_path"`

# Append injected scripts to the test project
cd "$integration_path/injections"
destination_file="$repo_path/test/assert.sh"
injections=`ls`

for injection in $injections
do
    name=`basename $injection`
    cat "$injection" >> "$destination_file"
done

# Append options to the test project
printf "TEST='%s'" '' >> "$destination_file"

# Trap early program exits to assure cleanup happens
clean()
{
    # Reset the state of the source repo
    make clean > /dev/null 2>&1
    git checkout HEAD -- "$destination_file" > /dev/null 2>&1
}

fail_early()
{
    # Assure clean is run before exiting
    clean
    exit 1
}

trap fail_early INT QUIT ABRT

# Run the test suite now that integration tests are merged in
cd "$repo_path"
make clean > /dev/null 2>&1
cflags='-ansi -pedantic -Wall -g'
make CFLAGS="$cflags" > /dev/null 2>&1
make check 2>&1
status=$?

# Run cleanup by hand if the tests didn't fail early
clean
exit $status
