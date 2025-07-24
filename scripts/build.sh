#!/bin/bash

# Licensed to the LF AI & Data foundation under one
# or more contributor license agreements. See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership. The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

TAG="main"
IMAGE_TAG="latest"

if command -v podman &> /dev/null; then
    CONTAINER_ENG="podman"
elif command -v docker &> /dev/null; then
    CONTAINER_ENG="docker"
else
    echo "Container engine is not installed on the system."
    exit 1
fi

if [ "$#" -eq 0 ]; then
    echo "Please set dockerfile path"
elif [ "$#" -eq 1 ]; then
    DOCKERFILE=$1
    $CONTAINER_ENG build -t build_milvus_lite:$IMAGE_TAG -f $DOCKERFILE . \
        && $CONTAINER_ENG run --rm -v $PWD:/workspace/dist build_milvus_lite:$IMAGE_TAG /workspace/build_milvus_lite.sh $TAG
elif [ "$#" -eq 2 ]; then
    DOCKERFILE=$1
    TAG=$2
    $CONTAINER_ENG build -t build_milvus_lite:$IMAGE_TAG -f $DOCKERFILE . \
        && $CONTAINER_ENG run --rm -v $PWD:/workspace/dist build_milvus_lite:$IMAGE_TAG /workspace/build_milvus_lite.sh $TAG
elif [ "$#" -eq 3 ]; then
    DOCKERFILE=$1
    TAG=$2
    CACAN_CACHE=$3
    $CONTAINER_ENG build -t build_milvus_lite:$IMAGE_TAG -f $DOCKERFILE . \
        && $CONTAINER_ENG run --rm -e CONAN_USER_HOME=/workspace/conan -v $CACAN_CACHE:/workspace/conan:Z -v $PWD:/workspace/dist build_milvus_lite:$IMAGE_TAG /workspace/build_milvus_lite.sh $TAG
fi
