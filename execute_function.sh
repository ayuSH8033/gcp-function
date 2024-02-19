#! /bin/bash

echo The name of the cloud-function is $1
export FUNCTION_NAME=$(echo "$1" | tr '_' '-')
sed 's/python-simple-http-endpoint/'"$FUNCTION_NAME"'/' serverless.yaml > cloudfunction.yaml
mv cloudfunction.yaml serverless.yaml
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
echo The name of the cloud-storage bucket is $2
export stack=$1
export gcpfunction=$1
export gcsBucket=$2
envsubst < configurable_functions.yaml > cloud-function.yaml
cat cloud-function.yaml
gcloud storage cp *.zip gs://$2  
gcloud deployment-manager deployments create ${stack} --config cloud-function.yaml  --async              



