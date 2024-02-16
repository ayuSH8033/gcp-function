pipeline {
    agent any
    environment {
    CLOUDSDK_CORE_PROJECT='infra-testing-2023'
    CLIENT_EMAIL=credentials('gcp-svc-Account')
    GCLOUD_CREDS=credentials('gcp-creds')
  }
        parameters{
                        choice(choices: ['deployment', 'undeployment'], description: 'Action to be performed on cloud function', name: 'action')
                        choice(choices: ['verify_location', 'user_details'], description: 'Name of the cloud Function', name: 'function') 
                        string(defaultValue: 'gs://function-test-420', description: 'URI of GCS bucket to be used by Cloud Function and Deployment Manager', name: 'CloudStorage')
                    }
    stages {
        stage('Deploying-services'){
            when {
                expression { params.action == 'deployment' }
            }
            steps{
                sh '''
                    export cloudFunction=${function}
                    export gcsBucket=${CloudStorage}
                    echo $cloudFunction
                    echo $gcsBucket
                    export stack=${function}
                    export gcpfunction=${function}
                    export gcsBucket=${CloudStorage}
                    envsubst < configurable_functions.yaml 
                    cat configurable_functions.yaml
                    chmod +x ./execute_function.sh
                    ./execute_function.sh $cloudFunction $gcsBucket
                    ls
                    diff swaggerv2.yaml swagger.yaml --unified=0 || true
                '''
                }   
}
                stage('cloudFunction-API-integration'){
                    when {
                     expression { params.action == 'deployment' }
                }
                        steps{
                            script {
                                    def USER_INPUT = input(
                                    message: 'User input required - Approve or Abort the api-merge request?',
                                    parameters: [
                                            [$class: 'ChoiceParameterDefinition',
                                            choices: ['Abort','Approve'].join('\n'),
                                            name: 'input',
                                           ]
                                    ])
                            echo "The option selected is: ${USER_INPUT}"
                            if( "${USER_INPUT}" == "Approve"){
                                sh '''
                                gcloud api-gateway api-configs create generic-updated-v2 --api=hello-world-api  --openapi-spec=swagger.yaml
                                gcloud api-gateway gateways update test --api=hello-world-api --api-config=generic-updated-v2 --location=us-central1
                                '''
                            } else {
                                echo "Abort option is selected,Skipping further operation"
                            }
                        }
                    }
                }
            stage('Removing-google-deployment-manager'){
                        when {
                            expression { params.action == 'undeployment' }
                        }
                steps{
                    sh '''
                    yes | gcloud deployment-manager deployments delete my-first-deployment  
                    '''
                    } 
                }  

}
}