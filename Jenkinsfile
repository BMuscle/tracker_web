pipeline {
  agent {
    docker {
      image 'ubuntbu'
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