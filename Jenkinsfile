pipeline {
  agent { docker { image 'ruby' } }
  stages {
    stage('build') {
      steps {
        sh 'ruby --version'
        sh 'find $WORKSPACE'
        sh 'env > env.txt'
        script {
            result = readFile('env').trim()
            println result
//          for (String i : readFile('env.txt').split("\r?\n")) {
//            println i
//          }
        }
      }
    }
  }
}
