#!/bin/sh
program=`basename $0`
integration_path=`dirname $0`

while getopts ':t:s:' option; do
    case "$option" in
        t)
            test_filter="$OPTARG"
            ;;
        s)
            suite_filter="$OPTARG"
            ;;
        :)
            printf "$program: missing value from option $OPTARG\n" 1>&2
            exit 1
            ;;
        ?)
            printf "$program: illegal option $OPTARG\n" 1>&2
            exit 1
            ;;
    esac
done

positional_start=$((OPTIND - 1))
shift $positional_start
repo_path=$1

if [ ! -d "$integration_path" ]
then
    printf '[ERROR] No integration path found.\n' 1>&2
    exit 1
fi

if [ ! -d "$repo_path" ]
then
    printf '[ERROR] No repo path found.\n' 1>&2
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
printf "TEST='%s'\n" "$test_filter" >> "$destination_file"
printf "SUITE='%s'\n" "$suite_filter" >> "$destination_file"

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
