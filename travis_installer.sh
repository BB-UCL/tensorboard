#!/usr/bin/env bash

# make protobufs for logging part first
make all

# get tensorflow
git clone https://github.com/tensorflow/tensorflow
cd tensorflow

# run configuration.
bash configure < ../tools/pip_wheel/configure.conf
# hack bazel compile time
git apply ../tools/pip_wheel/bazel-hacking.patch
# build tensorboard
bazel build tensorflow/tensorboard:tensorboard

# prepare pip installation package
cp -r ../tools/* bazel-bin/tensorflow/tools/
# get .whl file in python/dist/
bash bazel-bin/tensorflow/tools/pip_package/build_pip_package.sh ../python/dist/

# install tensorboard package from .whl file
cd ..
pip install python/dist/*.whl

# clean up
echo 'Now you can remove tensorflow with rm -rf tensorflow'
#rm -rf tensorflow/

