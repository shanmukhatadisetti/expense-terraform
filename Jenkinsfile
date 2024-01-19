pipeline {
 agent { label 'workstation' }
 stages {
  stage('Terraform Apply'){
   steps{
    sh 'terraform init -backend-config=env-${ENV}/state.tfvars'
    sh 'terraform plan -var-file=env-${ENV}/inputs.tfvars'
    }
   }
  }
 }