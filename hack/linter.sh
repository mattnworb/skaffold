#!/bin/bash

# Copyright 2019 The Skaffold Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if ! [ -x "$(command -v golangci-lint)" ]; then
	echo "Installing GolangCI-Lint"
	${DIR}/install_golint.sh -b $GOPATH/bin v1.17.1
fi

VERBOSE=""
if [[ "${TRAVIS}" == "true" ]]; then
    # Use less memory on Travis
    # See https://github.com/golangci/golangci-lint#memory-usage-of-golangci-lint
    export GOGC=10
    VERBOSE="-v --print-resources-usage"
fi

golangci-lint run ${VERBOSE} \
	--deadline=4m \
	--no-config \
    --disable-all \
    -E bodyclose \
    -E deadcode \
    -E goconst \
    -E gocritic \
    -E goimports \
    -E golint \
    -E gosimple \
    -E govet \
    -E ineffassign \
    -E interfacer \
    -E maligned \
    -E misspell \
    -E staticcheck \
    -E structcheck \
    -E stylecheck \
    -E typecheck \
    -E unconvert \
    -E unparam \
    -E unused \
    -E varcheck \
	--skip-dirs vendor | awk '/out of memory/ || /Deadline exceeded/ {failed = 1}; {print}; END {exit failed}'
