#!/bin/sh
program=`basename $0`
integration_path=`dirname $0`

while getopts ':t:s:h' option; do
    case "$option" in
        t)
            test_filter="$OPTARG"
            ;;
        s)
            suite_filter="$OPTARG"
            ;;
        h)
            printf 'Usage: %s [-t test] [-s suite] repo\n' "$program"
            exit 0
            ;;
        :)
            printf '[ERROR] Missing value from option.\n' 1>&2
            printf 'Argument: %s\n' "$OPTARG" 1>&2
            exit 1
            ;;
        ?)
            printf "[ERROR] Illegal option.\n" 1>&2
            printf 'Argument: %s\n' "$OPTARG" 1>&2
            exit 1
            ;;
    esac
done

positional_start=`expr $OPTIND - 1`
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

# Convert paths to absolute paths
integration_path=`readlink -f "$integration_path"`
repo_path=`readlink -f "$repo_path"`
count_file=`readlink -f count.sh`
test_file=`readlink -f test.sh`

# Safe-guard against data loss
cd "$repo_path"
destination_file="$repo_path/test/assert.sh"
git diff --exit-code --quiet "$destination_file"

if [ $? -eq 1 ]
then
    printf '[ERROR] Pending changes found for assert.sh.\n' 1>&2
    exit 1
fi

# Append overrides to utility script to count test cases
clean()
{
    # Reset the state of the source repo
    make clean > /dev/null 2>&1
    git checkout HEAD -- "$destination_file" > /dev/null 2>&1
}

cat "$count_file" >> "$destination_file"
cd "$repo_path"
make clean > /dev/null 2>&1
make > /dev/null 2>&1
cases=`make -s check`
clean

# Replace the utility script with a comment
printf '# Auto-generated by %s\n' "$program" > "$destination_file"

# Append options to the new utility script
printf "TEST='%s'\n" "$test_filter" >> "$destination_file"
printf "SUITE='%s'\n" "$suite_filter" >> "$destination_file"
printf "CASES='%s'\n" "$cases" >> "$destination_file"

# Trap early program exits to assure cleanup happens
fail_early()
{
    # Assure clean is run before exiting
    clean
    exit 1
}

trap fail_early INT QUIT ABRT

# Append overrides to the utility script to run this project's test functions
cat "$test_file" >> "$destination_file"
cd "$repo_path"
make clean > /dev/null 2>&1
cflags='-ansi -pedantic -Wall -g'
make CFLAGS="$cflags" > /dev/null 2>&1
make check
status=$?

# Run cleanup by hand if the tests didn't fail early
clean
exit $status
