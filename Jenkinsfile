pipeline {
  agent { docker { image 'ruby' } }
  environment {
    GITHUB_ORG = 'ghoneycutt'
    GH_CREDS = credentials('301c75f1-0f6f-4643-9c16-1dec83e489ab')
    TERRAFORM_ZIP_URL = 'https://releases.hashicorp.com/terraform/0.12.6/terraform_0.12.6_linux_amd64.zip'
  }
  stages {
    stage('build') {
      steps {
        sh 'ruby --version'
        sh 'cd .ci && bundle install && cd ..'
        sh 'wget -q $TERRAFORM_ZIP_URL'
        sh 'unzip -o terraform*.zip'
        script {
          sh './terraform --version'
          FMT_STATUS == sh (
            script: './terraform fmt -check -diff',
            returnStatus: true
          ) == 0
          if (FMT_STATUS == 0) {
            echo "zero -- FMT_STATUS = $FMT_STATUS"
          } else {
            echo "non-zero -- FMT_STATUS = $FMT_STATUS"
            echo "will need to mark this as failed"
            sh 'false'
          }
          sh './terraform init -no-color'
          sh './terraform plan -out plan -no-color > cmd.out.plan'
          sh 'ruby ./.ci/comment.rb cmd.out.plan'
        }
      }
    }
  }
}
