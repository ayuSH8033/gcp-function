#! /bin/bash

##########GETTING URL OF DEPLOYED FUNCTION FROM GCP#########
gcloud functions describe python-simple-http-endpoint-test | yq '.url'

#####FETCHING CONFIG OF RUNNING API FROM GCP#######
gcloud api-geway api-configs describe generic-v2 --api=hello-world-api --view=FULL | yq '.openapiDocuments[0].document.contents' | base64 --decode > swagger-v2.yaml
cat swagger-v2.yaml

#######CREATING NEW SWAGGER FOR UPDATING THE FUNCTION URL###########
cp swagger-v2.yaml swagger-updated-v2.yaml

#####UPDATING NEW SWAGGER WITH FUNCTION URL#######
yq -i '.paths./*.get.x-google.backend.address = "https://us-central1-infra-testing-2023.cloudfunctions.net/python-function"' swagger-updated-v2.yaml 
OR
sed 's/helloGET/'"$1"'/' swagger-updated-v2.yaml > swagger-updated-v2.yaml

#######CREATING REQUEST OF MERGE UPON USER INPUT#######
diff swagger-v2.yaml swagger-updated-v2.yaml
Jenkins stage of approve and reject 

######IF USER APPROVES#######
yq ea '. as $item ireduce ({}; . * $item )' swagger-v2.yaml swagger-updated-v2.yaml >> final-merged-swagger.yaml

######AFTER USER APPROVAL#######
gcloud api-gateway api-configs create ${CONFIG-NAME} --api=hello-world-api --final-mereged-swagger.yaml

######CREATE NEW CONFIG INTEGRATED WITH GATEWAY########
gcloud api-gateway gateways update ${GATEWAY-ID} --api=hello-worl-api --api-config=${CONFIG-NAME} --location=us-central1

##########RENAMEING THE SERVICE IN SERVERLESS YAML##########
export FUNCTION_NAME=$(echo "${cloudFunction}" | tr '_' '-')
sed 's/python-simple-http-endpoint/'"$FUNCTION_NAME"'/' serverless.yaml > new.yaml
mv new.yaml serverless.yaml

#######RENAMING CURRENT API CONFIG FROM latest TO v2 AND CREATE NEW CONFIG WITH NAME latest USING YAML PROVIDED DURING FUNCTION BUILD#################
gcloud api-gateway api-configs update <$CURRENT-CONFIG> --api=first-api-new --display-name="v2"
gcloud api-gateway api-configs create <$latest> --api=hello-world-api  --openapi-spec=swagger.yaml

#######DEPLOY API GATEWAY WITH UPDATED CONFIG###########
gcloud api-gateway gateways update test --api=hello-world-api --api-config=generic-updated-v2 --location=us-central1 