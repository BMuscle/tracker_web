pipeline {
  agent {
    node {
      label 'dood'
    }

  }
  stages {
    stage('test') {
      agent any
      steps {
        sh 'echo "Hello"'
      }
    }

  }
}