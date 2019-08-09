pipeline {
  agent { docker { image 'ruby' } }
  stages {
    stage('build') {
      steps {
        sh 'ruby --version'
        sh 'find $WORKSPACE'
        sh 'env > env.txt'
        script {
          for (String i : readFile('env.txt').split("\r?\n")) {
            println i
          }
        }
      }
    }
  }
}
