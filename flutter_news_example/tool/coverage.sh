#!/bin/bash

# This script can be used to run flutter test for a given directory (defaults to the current directory)
# It will exclude generated code and translations (mimicking the ci) and open the coverage report in a
# new window once it has run successfully.
#
# To run in main project:
# ./tool/coverage.sh
#
# To run in other directory:
# ./tool/coverage.sh ./path/to/other/project

set -e

PROJECT_PATH="${1:-.}"
PROJECT_COVERAGE=./coverage/lcov.info

cd ${PROJECT_PATH}

rm -rf coverage
fvm flutter --version
very_good test --coverage --exclude-coverage "**/*.g.dart **/*.gen.dart **/l10n/*.dart **/l10n/**/*.dart **/main/bootstrap.dart" --exclude-tags 'presubmit-only' --test-randomize-ordering-seed random

lcov --remove ${PROJECT_COVERAGE} -o ${PROJECT_COVERAGE} \
    '**/*.g.dart' \
    '**/l10n/*.dart' \
    '**/l10n/**/*.dart' \
    '**/main/bootstrap.dart' \
    '**/*.gen.dart'

genhtml ${PROJECT_COVERAGE} -o coverage | tee ./coverage/output.txt

COV_LINE=$(tail -2 ./coverage/output.txt | head -1)
SUB='100.0%'

if [[ "$COV_LINE" == *"$SUB"* ]]; then
    echo "The coverage is 100%"
else
    echo "Coverage is below 100%! Check the report to see which lines are not covered."
    echo $COV_LINE
    open ./coverage/index.html
fi
