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
        sh 'pwd'
        sh 'ls'
        script {
          sh './terraform --version > cmd.out.ver'
          sh 'ruby ./.ci/comment.rb cmd.out.ver'
          sh './terraform init -no-color > cmd.out.init'
          sh 'ruby ./.ci/comment.rb cmd.out.init'
          sh './terraform plan -out plan -no-color > cmd.out.plan'
          sh 'ruby ./.ci/comment.rb cmd.out.plan'
        }
      }
    }
  }
}
