pipeline {
  agent { docker { image 'ruby' } }
  environment {
    GH_CREDS = credentials('301c75f1-0f6f-4643-9c16-1dec83e489ab')
    TERRAFORM_ZIP_URL = 'https://releases.hashicorp.com/terraform/0.12.6/terraform_0.12.6_linux_amd64.zip'
  }
  stages {
    stage('build') {
      steps {
        sh 'ruby --version'
        sh 'apt-get -f install wget zip'
        sh 'wget $TERRAFORM_ZIP_URL'
        sh 'unzip terraform*.zip'
        script {
          TERRAFORM_OUT = sh (
            script: 'terraform --version',
            returnStdout: true,
            returnStatus: true
          )
        }
        sh 'echo -e TERRAFORM_OUT = $TERRAFORM_OUT'
        sh 'find $WORKSPACE'
        sh 'env > env.txt'
        sh 'ruby .ci/comment.rb'
        script {
            result = readFile('env.txt').trim()
            println result
            println TERRAFORM_OUT
//          for (String i : readFile('env.txt').split("\r?\n")) {
//            println i
//          }
        }
      }
    }
  }
}
