pipeline {
  // Replace 'ruby' image with custom image. We could start with the official
  // ruby image and then add terraform.
  agent { docker { image 'ruby' } }
  environment {
    GITHUB_ORG = 'ghoneycutt'
    GH_CREDS = credentials('301c75f1-0f6f-4643-9c16-1dec83e489ab')

    // This should be baked into the container, see comments below.
    TERRAFORM_ZIP_URL = 'https://releases.hashicorp.com/terraform/0.12.6/terraform_0.12.6_linux_amd64.zip'
  }
  stages {
    stage('debug') {
      steps {
        echo "Environment variables"
        sh 'env'
      }
    }
    stage('build') {
      steps {
        // bake into container
        sh 'ruby --version' // debugging info
        sh 'cd .ci && bundle install && cd ..' // install dependencies
        sh 'wget -q $TERRAFORM_ZIP_URL' // download terraform
        sh 'unzip -o terraform*.zip' // install terraform
        sh './terraform --version'
        // end of commands to bake into container
      }
    }
    stage('fmt') {
      steps {
        script {
          fmt_status = sh (
            script: './terraform fmt -check -diff -recursive > cmd.out.fmt',
            returnStatus: true
          )
          echo "fmt_status = $fmt_status" // debugging info
          if (fmt_status != 0) { // on error, show the diff in the PR, else move along
            sh 'ruby ./.ci/comment.rb cmd.out.fmt diff'
            error("The terraform files have not been properly formatted.")
          }
        }
      }
    }
    stage('init') {
      steps {
        sh './terraform init -no-color'
      }
    }
    stage('plan') {
      steps {
        sh './terraform plan -out plan -no-color > cmd.out.plan'
        sh 'ruby ./.ci/comment.rb cmd.out.plan'
      }
    }
  }
}
