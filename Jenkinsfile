// plugins:
//    Docker Pipeline (docker-workflow): 1.19
//    GitHub Branch Source Plugin (github-branch-source): 2.5.5
//    Pipeline: GitHub (pipeline-github): 2.5
//    Pipeline Utility Steps (pipeline-utility-steps): 2.3.0
//
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
    stage('install_dependencies') {
      steps {
        // bake into container
        sh 'mkdir -p .ci' // create .ci directory
        sh 'wget -q $TERRAFORM_ZIP_URL' // download terraform
        sh 'unzip -o terraform*.zip -d .ci/' // install terraform
        sh './.ci/terraform --version'
        // end of commands to bake into container
      }
    }
    stage('determine_tf_dir') {
      steps {
        script {
          project_map = readYaml (file: "project_map.yaml")
          echo "project_map = ${project_map}"

          // The change_set will come from `git diff`. Using yaml files now to
          // expedite development.
          change_set = readYaml (file: "l1.yaml")
          echo "change_set = ${change_set}"
          change_set_length = change_set.size()
          echo "change_set_length = ${change_set_length}"

          for (i=0; i<change_set_length; i++) {
            echo "i = ${i} :: change_set[i] = ${change_set[i]}"
            if ( change_set[i] ==~ /.+\.(tf|tfvars)$/ ) { // ending in .tf or .tfvars
              //echo "match"
              def dirname = java.nio.file.Paths.get(change_set[i]).getParent().toString();
              echo "dirname = ${dirname}"
            }
          }
        }
      }
    }
    stage('init') {
      steps {
        script {
          init_status = sh (
            script: './.ci/terraform init -no-color -input=false > cmd.out.init 2>&1',
            returnStatus: true
          )
          echo "init_status = ${init_status}" // debugging info
          output = readFile 'cmd.out.init'
          echo "${output}" // debugging info
          if (init_status != 0) { // on error, show the output in the PR, else move along
            script {
              pullRequest.comment("```\n${output}\n```")
              error("'terraform init' returned non-zero.")
            }
          }
        }
      }
    }
    stage('fmt') {
      steps {
        script {
          fmt_status = sh (
            script: './.ci/terraform fmt -check -diff -recursive -no-color > cmd.out.fmt 2>&1',
            returnStatus: true
          )
          echo "fmt_status = ${fmt_status}" // debugging info
          output = readFile 'cmd.out.fmt'
          echo "${output}" // debugging info
          if (fmt_status != 0) { // on error, show the diff in the PR, else move along
            script {
              pullRequest.comment("```diff\n${output}\n```")
              error("The terraform files have not been properly formatted.")
            }
          }
        }
      }
    }
    stage('plan') {
      steps {
        script {
          plan_status = sh (
            script: './.ci/terraform plan -out plan -no-color > cmd.out.plan 2>&1',
            returnStatus: true
          )
          echo "plan_status = ${plan_status}" // debugging info
          output = readFile 'cmd.out.plan'
          echo "${output}" // debugging info
          pullRequest.comment("```\n${output}\n```")
          if (plan_status != 0) { // fail build if plan returns non-zero
            script {
              error("'terraform plan' returned non-zero.")
            }
          }
        }
      }
    }
  }
}
