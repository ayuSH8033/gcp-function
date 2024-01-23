#! /bin/bash

##########GETTING URL OF DEPLOYED FUNCTION FROM GCP#########
gcloud functions describe python-simple-http-endpoint-test | yq '.url'

#####FETCHING CONFIG OF RUNNING API FROM GCP#######
gcloud api-gateway api-configs describe generic-v2 --api=hello-world-api --view=FULL | yq '.openapiDocuments[0].document.contents' | base64 --decode > swagger.yaml
cat swagger.yaml

#######CREATING NEW SWAGGER FOR UPDATING THE FUNCTION URL###########
cp swagger.yaml swagger-v2.yaml

#####UPDATING NEW SWAGGER WITH FUNCTION URL#######
yq -i '.paths./*.get.x-google.backend.address = "https://us-central1-infra-testing-2023.cloudfunctions.net/python-function"' swagger-v2.yaml 

#######CREATING REQUEST OF MERGE UPON USER INPUT#######
diff swagger.yaml swagger-v2.yaml
Jenkins stage of approve and reject 

######IF USER APPROVES#######
yq ea '. as $item ireduce ({}; . * $item )' swagger.yaml swagger-v2.yaml >> final-swagger.yaml

######AFTER USER APPROVAL#######
gcloud api-gateway api-configs create ${CONFIG-NAME} --api=hello-world-api --final-swagger.yaml

######CREATE NEW CONFIG INTEGRATED WITH GATEWAY########
gcloud api-gateway gateways update ${GATEWAY-ID} --api=hello-worl-api --api-config=${CONFIG-NAME} --location=us-central1
