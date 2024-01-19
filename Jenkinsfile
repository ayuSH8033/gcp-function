pipeline {
    agent any
    environment {
    CLOUDSDK_CORE_PROJECT='infra-testing-2023'
    CLIENT_EMAIL='infra-manager-testing-sa@infra-testing-2023.iam.gserviceaccount.com'
    GCLOUD_CREDS=credentials('gcp-creds')
  }

    parameters {
        choice(
            choices: ['execution'],
            description: 'Packaging the function and uploading the same into bucket',
            name: 'action')
        choice(
            choices: ['verify_location','user_details'],
            description: 'Name of the cloud Function',
            name: 'function-name')
    }
    stages {
        stage('Zip-generation'){
            when {
                expression { params.action == 'execution' }
            }
    steps{
        sh '''
            chmod +x ./execute_function.sh
            echo ${function-name}
            ./execute_function.sh ${function-name}
            ls
        '''
        }   
}
    //     stage('Plan') {
    //         when {
    //             expression { params.action == 'plan' }
    //         }
    //         steps {
    //             sh '''
    //              ls
    //              /opt/homebrew/bin/tofu --help
    //              cd modules/${module}
    //              /opt/homebrew/bin/tofu init
    //              /opt/homebrew/bin/tofu plan -var-file=../../variables/dev/${module}/terraform.tfvars
    //             '''
    //         }
    //     }

    // stage('apply') {
    //         when {
    //             expression { params.action == 'apply' }
    //         }
    //         steps {
    //             sh '''
    //              ./google-cloud-sdk/bin/gcloud auth activate-service-account --key-file ${GCLOUD_CREDS}
    //             ls
    //              cd modules/${module}
    //              /opt/homebrew/bin/tofu init
    //              /opt/homebrew/bin/tofu plan -var-file=../../variables/dev/${module}/terraform.tfvars
    //              /opt/homebrew/bin/tofu apply -var-file=../../variables/dev/${module}/terraform.tfvars --auto-approve
    //              '''
    //         }
    //     }

    //     stage('destroy') {
    //         when {
    //             expression { params.action == 'destroy' }
    //         }
    //         steps {
    //             sh '''
    //              ./google-cloud-sdk/bin/gcloud auth activate-service-account --key-file ${GCLOUD_CREDS}
    //             ls
    //              cd modules/${module}
    //              /opt/homebrew/bin/tofu init
    //              /opt/homebrew/bin/tofu plan -var-file=../../variables/dev/${module}/terraform.tfvars
    //              /opt/homebrew/bin/tofu destroy -var-file=../../variables/dev/${module}/terraform.tfvars --auto-approve
    //              '''
    //         }
    //     }
}
}