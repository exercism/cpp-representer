#!/usr/bin/env sh

# Synopsis:
# Test the representer by running it against a predefined set of solutions 
# with an expected output.

# Output:
# Outputs the diff of the expected representation and mapping against the
# actual representation and mapping generated by the representer.

# Example:
# ./bin/run-tests.sh

exit_code=0

# Iterate over all test directories
for test_dir in tests/*; do
    test_dir_name=$(basename "${test_dir}")
    test_dir_path=$(realpath "${test_dir}")
    representation_file_path="${test_dir_path}/representation.txt"
    expected_representation_file_path="${test_dir_path}/expected_representation.txt"
    mapping_file_path="${test_dir_path}/mapping.json"    
    expected_mapping_file_path="${test_dir_path}/expected_mapping.json"
    representation_json_file_path="${test_dir_path}/representation.json"
    expected_representation_json_file_path="${test_dir_path}/expected_representation.json"
    expect_error="${test_dir_path}/.expect-error"

    bin/run.sh "${test_dir_name}" "${test_dir_path}" "${test_dir_path}"
    test_exit_code=$?

    if [[ -f "${expect_error}" ]]; then
        if [[ $test_exit_code -eq 0 ]]; then
            echo 'Expected non-zero exit code'
            exit_code=1
        fi
    else
        echo "${test_dir_name}: comparing representation.txt to expected_representation.txt"
        diff "${representation_file_path}" "${expected_representation_file_path}"

        if [ $? -ne 0 ]; then
            exit_code=1
        fi

        echo "${test_dir_name}: comparing mapping.json to expected_mapping.json"
        diff "${mapping_file_path}" "${expected_mapping_file_path}"

        if [ $? -ne 0 ]; then
            exit_code=1
        fi

        echo "${test_dir_name}: comparing representation.json to expected_representation.json"
        diff "${representation_json_file_path}" "${expected_representation_json_file_path}"

        if [ $? -ne 0 ]; then
            exit_code=1
        fi
    fi
done

exit ${exit_code}
