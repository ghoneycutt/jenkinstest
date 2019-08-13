pipeline {
  agent { docker { image 'jenkinsci/slave' } }
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
            script {
              output = readFile 'cmd.out.fmt'
              pullRequest.comment("```diff\n${output}\n```")
              error("The terraform files have not been properly formatted.")
            }
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
        script {
          output = readFile "cmd.out.plan"
          pullRequest.comment("```\n${output}\n```")
        }
      }
    }
  }
}
