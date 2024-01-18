#! /bin/bash
# echo Hello, Please enter the function name that is to be deployed on GCP
# read function
echo The name of the function is ${params.function-name}
mkdir function_code
cp -r ${params.function-name} utils function_code
cp serverless.yaml swagger.yaml main.py function_code
cp ${params.function-name}/requirements.txt function_code
cd function_code
sls plugin install -n serverless-python-requirements
sls plugin install -n serverless-google-cloudfunctions
sls package --verbose
cp .serverless/*.zip ../
cd ..
rm -rf function_code
