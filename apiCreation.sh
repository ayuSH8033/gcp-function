#! /bin/bash

gcloud api-geway api-configs describe generic-v2 --api=hello-world-api --view=FULL | yq '.openapiDocuments[0].document.contents' | base64 --decode > swagger-v2.yaml
cat swagger-v2.yaml
cp swagger-v2.yaml swagger-updated-v2.yaml
sed 's/helloGET/'"$1"'/' swagger-updated-v2.yaml > swagger-updated-v2.yaml

