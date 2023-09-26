#!/usr/bin/env bash

# Synopsis:
# Run the representer on a solution.

# Arguments:
# $1: exercise slug
# $2: absolute path to solution folder
# $3: absolute path to output directory

# Output:
# Writes the test mapping to a mapping.json file in the passed-in output directory.
# The test mapping are formatted according to the specifications at https://github.com/exercism/docs/blob/main/building/tooling/representers/interface.md

# Example:
# ./bin/run.sh two-fer /absolute/path/to/two-fer/solution/folder/ /absolute/path/to/output/directory/

# If any required arguments is missing, print the usage and exit
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "usage: ./bin/run.sh exercise-slug /absolute/path/to/two-fer/solution/folder/ /absolute/path/to/output/directory/"
    exit 1
fi

slug="$1"
input_dir="${2%/}"
output_dir="${3%/}"
script_path=$(readlink -f ${BASH_SOURCE[0]})
bin_path=$(dirname ${script_path})
process_file="${bin_path}/process.py"

# Create the output directory if it doesn't exist
mkdir -p "${output_dir}"

echo "${slug}: creating representation..."

# Run the representer process
python3 "${process_file}" "${input_dir}" "${output_dir}"
representer_result=$?

# Exit if there an error occured while processing the solution files
if [ "${representer_result}" -ne 0 ]; then
    echo "${slug}: failed with error code ${representer_result}"
else
    echo "${slug}: done"
fi

exit "${representer_result}"
