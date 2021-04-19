#!/usr/bin/env bash

: ${DEV_CONTAINER:=code_1}
SCRIPT_NAME=$(basename $0)

# Certain commands from IntelliJ issues absolute paths from the
# local filesystem, but the container has the root of the source
# tree set as the working directory. So just remove all the local
# paths and it'll all work out
PROJECT_ROOT_DIRECTORY="$(git rev-parse --show-toplevel)/"
function relativize() {
    echo $@ | sed "s#${PROJECT_ROOT_DIRECTORY}##"
}

function relativize-all-the-arguments() {
    local args=""

    for i in $@; do
        i=$(relativize "$i")
        args="${args} ${i}"
    done

    echo ${args}
}

exec /usr/local/bin/docker exec ${DEV_CONTAINER} \
    /usr/bin/env ${SCRIPT_NAME} $(relativize-all-the-arguments $@)
