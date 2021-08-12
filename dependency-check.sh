#!/bin/bash

OWASPDC_DIRECTORY="$PWD/OWASP-Dependency-Check"
DATA_DIRECTORY="$OWASPDC_DIRECTORY/data"
REPORT_DIRECTORY="$OWASPDC_DIRECTORY/reports"


if [ ! -d "$DATA_DIRECTORY" ]; then
   sudo echo "Initially creating persistent directories"
   sudo mkdir -p "$DATA_DIRECTORY"
    sudo chmod -R 777 "$DATA_DIRECTORY"

    sudo mkdir -p "$REPORT_DIRECTORY"
    sudo chmod -R 777 "$REPORT_DIRECTORY"
fi

sudo docker pull owasp/dependency-check

sudo docker run --rm \
    --volume $(pwd):/src \
    --volume "$DATA_DIRECTORY":/usr/share/dependency-check/data \
    --volume "$REPORT_DIRECTORY":/report \
    owasp/dependency-check \
    --scan /src \
    --format "ALL" \
    --project "My OWASP Dependency Check Project" \
    --out /report
    # Use suppression like this: (/src == $pwd)
