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
# export $stack=$1
# export $gcpfunction=$1
# export $gcsBucket=$2
# envsubst < configurable_functions.yaml 
# cat configurable_functions.yaml 
# gcloud storage cp *.zip $2  
# gcloud deployment-manager deployments create $1-deployment --config configurable_functions.yaml  --async                
# gcloud api-gateway api-configs describe generic-v2 --api=hello-world-api --view=FULL | yq '.openapiDocuments[0].document.contents' | base64 --decode > swaggerv2.yaml
# cat swaggerv2.yaml