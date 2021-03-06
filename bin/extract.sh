#!/bin/bash

script="$0"
FOLDER="$(pwd)/$(dirname $script)"

source $FOLDER/utils.sh
PROJECT_ROOT="$(abspath $FOLDER/..)"
echo "project root folder $PROJECT_ROOT"

echo "build docker image"
/bin/bash $FOLDER/build.sh

##### VOLUMES #####

# folder containing data
DATA_DIR=$PROJECT_ROOT/data
echo "Using data in $DATA_DIR"

# folder containing outputz
OUTPUT_DIR=$PROJECT_ROOT/output
echo "Writing outputs to $OUTPUT_DIR"

# folder containing custom model definition
CUSTOM_MODEL_DIR=$PROJECT_ROOT/custom_heads/reference_model
echo "Custom model is in $CUSTOM_MODEL_DIR"

##### RUN #####
echo "Starting container..."

docker run --rm \
           -it \
           -v $DATA_DIR:/data \
           -v $OUTPUT_DIR:/output \
           -v $CUSTOM_MODEL_DIR:/resnet_50/model/custom_model \
           dominicbreuker/resnet_50_docker:latest \
           /bin/sh -c "python /resnet_50/extracting.py -e jpg -head custom -fcn True -hs 300 -ws 300"
