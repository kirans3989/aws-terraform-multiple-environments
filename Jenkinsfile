pipeline {
    agent any

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'staging', 'prod'],
            description: 'Select the environment to manage Terraform code'
        )
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select the Terraform action to perform (apply to deploy, destroy to remove)'
        )
    }

    environment {
        TF_WORKSPACE = "${params.ENVIRONMENT}" // Terraform workspace matches the environment
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Clone the Terraform code repository
                    git branch: 'main', url: 'https://github.com/kirans3989/aws-terraform-multiple-environments.git'
                }
            }
        }

        stage('Select Environment and Action') {
            steps {
                script {
                    echo "Environment selected: ${params.ENVIRONMENT}"
                    echo "Action selected: ${params.ACTION}"
                }
            }
        }

        stage('Approval') {
            steps {
                script {
                    // Approval prompt for the selected action
                    input message: "Approve ${params.ACTION} action for ${params.ENVIRONMENT} environment?"
                }
            }
        }

       stage('Setup') {
            steps {
                script {
                    // Initialize Terraform and handle workspace selection
                    sh '''
                    terraform init
            
                    # Unset TF_WORKSPACE to avoid conflicts during workspace selection
                    unset TF_WORKSPACE
            
                    # Select or create the workspace
                    terraform workspace select ${ENVIRONMENT} || terraform workspace new ${ENVIRONMENT}
                    '''
                }
            }
        }

        stage('Debug') {
    steps {
        script {
            sh '''
            terraform show
            terraform state list
            '''
        }
    }
}

        stage('Plan') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    // Generate and display Terraform plan for apply
                    sh "terraform plan -var-file=environments/${TF_WORKSPACE}.tfvars"
                }
            }
        }

        stage('Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    // Apply the Terraform plan
                    sh "terraform apply -var-file=environments/${TF_WORKSPACE}.tfvars"
                }
            }
        }

        stage('Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                script {
                    // Destroy Terraform-managed infrastructure
                    sh "terraform destroy -auto-approve"
                }
            }
        }
    }

    post {
        always {
            // Cleanup Terraform plan file if it exists
            script {
                sh "rm -f plan-${TF_WORKSPACE}.tfplan || true"
            }
        }
        success {
            echo "Terraform ${params.ACTION} action for ${params.ENVIRONMENT} environment completed successfully."
        }
        failure {
            echo "Terraform ${params.ACTION} action for ${params.ENVIRONMENT} environment failed."
        }
    }
}
