pipeline {
    agent any
    environment {
    CLOUDSDK_CORE_PROJECT='infra-testing-2023'
    CLIENT_EMAIL='infra-manager-testing-sa@infra-testing-2023.iam.gserviceaccount.com'
    GCLOUD_CREDS=credentials('gcp-creds')
  }

    parameters {
        choice(
            choices: ['deployment','undeployment', 'testing'],
            description: 'Packaging the function and uploading the same into bucket',
            name: 'action')
        choice(
            choices: ['verify_location','user_details'],
            description: 'Name of the cloud Function',
            name: 'function')
    }
    stages {
    //     stage('Manipulate Yaml file') {
    //      def config = readYaml file: "./configurable_functions.yaml"
    //      config.metadata.name = params.function-name
    //      writeYaml file: "./configurable_functions.yaml", data: config
    //   }
      stage('checking-name-updation-in-YAML'){
        when {
                expression { params.action == 'testing' }
            }
            steps{
                sh '''
                export FUNCTION=${function}
                chmod +x ./updation.sh
            ./updation.sh $FUNCTION
            '''
        }
      }
        stage('Zip-generation'){
            when {
                expression { params.action == 'deployment' }
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
                stage('api-comparison'){
                         when {
                expression { params.action == 'deployment' }
                }
                     steps {
                     sh '''
                      (( $? < 2 )) && true
                      diff openapi2-function.yaml openapiv2.yaml --unified=0 || true
                      '''
                    //    script {
                    //         def USER_INPUT = input(
                    //                 message: 'User input required - Some Approve or Abort question?',
                    //                 parameters: [
                    //                         [$class: 'ChoiceParameterDefinition',
                    //                         choices: ['Abort','Approve'].join('\n'),
                    //                         name: 'input',
                    //                         description: 'Menu - select option to be performed']
                    //                 ])

                    //         echo "The answer is: ${USER_INPUT}"

                    //         if( "${USER_INPUT}" == "Approve"){
                    //             sh '''
                    //             ls
                    //             '''
                    //         } else {
                    //             echo "Skipped"
                    //         }
                    //     }
                    }
                }
                stage('cloudFunction-API-integration'){
                    when {
                expression { params.action == 'deployment' }
                }
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