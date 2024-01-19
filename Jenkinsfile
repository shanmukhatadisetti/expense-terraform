pipeline {
 agent { label 'workstation' }
 parameters {
  choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Choose Environment')
  }
 stages {
  stage('Terraform Apply'){
   steps{
    sh 'terraform init -backend-config=env-${ENV}/state.tfvars'
    sh 'terraform plan -var-file=env-${ENV}/inputs.tfvars'
    }
   }
  }
 }