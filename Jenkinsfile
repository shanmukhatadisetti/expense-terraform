pipeline {
 agent { label 'workstation' }
 parameters {
  choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Choose Environment')
  choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose Action')
  }
 options {
   ansiColor('xterm')
  }
 stages {
  stage('Terraform Plan'){
   steps{
    sh 'terraform init -backend-config=env-${ENV}/state.tfvars'
    sh 'terraform ${ACTION} -var-file=env-${ENV}/inputs.tfvars'
    }
   }
  stage('Terraform Apply'){
   input {
    message "Should we continue?"
    }
   steps{
    sh 'terraform ${ACTION} -var-file=env=${ENV}/inputs.tfvars -auto-approve'
    }
   }
  }
 }