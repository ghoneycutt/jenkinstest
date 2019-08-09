pipeline {
  agent { docker { image 'ruby' } }
  environment {
    GH_CREDS = credentials('301c75f1-0f6f-4643-9c16-1dec83e489ab')
  }
  stages {
    stage('build') {
      steps {
        sh 'ruby --version'
        sh 'echo -e =================\n\n$CREDS\n\n'
        sh 'find $WORKSPACE'
        sh 'env > env.txt'
        script {
            result = readFile('env.txt').trim()
            println result
//          for (String i : readFile('env.txt').split("\r?\n")) {
//            println i
//          }
        }
      }
    }
  }
}
