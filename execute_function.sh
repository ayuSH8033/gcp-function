#! /bin/bash

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
echo The name of the cloud-storage bucket is $2
export stack=${function}
export gcpfunction=${function}
export gcsBucket=${CloudStorage}
envsubst < configurable_functions.yaml > cloud-function.yaml
cat cloud-function.yaml
gcloud storage cp *.zip gs://$2  
gcloud deployment-manager deployments create $1 --config cloud-function.yaml  --async                