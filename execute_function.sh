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
gcloud storage cp *.zip gs://function-test-420  
gcloud deployment-manager deployments create my-first-deployment --config configurable_functions.yaml  --async                
gcloud api-gateway api-configs describe generic-v2 --api=hello-world-api --view=FULL | yq '.openapiDocuments[0].document.contents' | base64 --decode > swaggerv2.yaml
cat swaggerv2.yaml
cp swaggerv2.yaml swaggerv2-updated.yaml
sed 's/function-1/'"$1"'/' swaggerv2-updated.yaml > swaggerv2-updated.yaml