#! /bin/bash
# echo Hello, Please enter the function name that is to be deployed on GCP
# read function
echo The name of the function is $1
mkdir function_code
cp -r $1 utils function_code
cp serverless.yaml swagger.yaml main.py function_code
cp $1/requirements.txt function_code
cd function_code
sls plugin install -n serverless-python-requirements
sls plugin install -n serverless-google-cloudfunctions
sls package --verbose
cp .serverless/*.zip ../
cd ..
rm -rf function_code
gcloud storage cp *.zip gs://function-test-420  
gcloud deployment-manager deployments create my-first-deployment --config configurable_functions.yaml  --async                