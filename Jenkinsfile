pipeline {
    agent any
    environment {
    CLOUDSDK_CORE_PROJECT='infra-testing-2023'
    CLIENT_EMAIL='infra-manager-testing-sa@infra-testing-2023.iam.gserviceaccount.com'
    GCLOUD_CREDS=credentials('gcp-creds')
  }

    parameters {
        choice(
            choices: ['execution', 'undeployment','deployment'],
            description: 'Packaging the function and uploading the same into bucket',
            name: 'action')
        choice(
            choices: ['verify_location','user_details'],
            description: 'Name of the cloud Function',
            name: 'function')
    }
    stages {
        stage('Zip-generation'){
            when {
                expression { params.action == 'execution' }
            }
    steps{
        sh '''
            export gcs=${cloudBucket}
            export cloudFunction=${function}
            echo $cloudFunction
            chmod +x ./execute_function.sh
            ./execute_function.sh $cloudFunction
            ls
        '''
        }   
}
            stage('Removing-google-deploymen-manager'){
                        when {
                            expression { params.action == 'undeployment' }
                        }
                steps{
                    sh '''
                    yes | gcloud deployment-manager deployments delete my-first-deployment  
                    '''
                    } 
                }  
                stage('api-cloudFunction-Integration')
                {
                    steps{
                         when {
                expression { params.action == 'execution' }
                }
                     sh '''
                      diff openapi2-function.yaml openapiv2.yaml --unified=0
                      '''
                    }
                }
                stage('cloudFunction-API-integration'){
                        steps{
                            script {
                            def USER_INPUT = input(
                                    message: 'User input required - Some Approve or Abort question?',
                                    parameters: [
                                            [$class: 'ChoiceParameterDefinition',
                                            choices: ['Abort','Approve'].join('\n'),
                                            name: 'input',
                                            description: 'Menu - select option to be performed']
                                    ])

                            echo "The answer is: ${USER_INPUT}"

                            if( "${USER_INPUT}" == "Approve"){
                                sh '''
                                ls
                                '''
                            } else {
                                echo "Skipped"
                            }
                        }
                    }
                }

}
}