pipeline {
  agent any
  stages {
  stage('build') {
    steps {
        echo 'build'
    }
  }

  stage('test') {
    steps {
        echo 'test'
    }
  }

  stage('deploy') {
    steps {
        echo 'deploy'
        sh 'php -S localhost:8888'
    }
  }
 }
}