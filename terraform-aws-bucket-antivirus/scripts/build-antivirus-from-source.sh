#!/usr/bin/env bash
set -e

DIR=$PWD/terraform-aws-bucket-antivirus/lambda-code

echo "Current DIR : $DIR"
# rm -rf bin/
cd $DIR

# echo "Removing complete-s3 Builds"
# rm -rf build/

# make archive
echo "Builds Packed"
