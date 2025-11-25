pipeline {
  agent any

  environment {
    IMAGE = "YOUR_DOCKERHUB/website"
    TAG   = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
  }

  stages {

    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE}:${TAG} ."
      }
    }

    stage('Test') {
      steps {
        sh '''
          if [ -f index.html ]; then
            echo "Tests Passed"
          else
            echo "index.html NOT found"; exit 1
          fi
        '''
      }
    }

    stage('Push & Deploy (Master Only)') {
      when { branch 'master' }
      steps {
        script {
          def day = sh(script: "date +%d", returnStdout: true).trim()
          if(day == "25"){
            echo "Today is 25th, deploying"
            withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]){
              sh 'echo "$PASS" | docker login -u "$USER" --password-stdin'
              sh "docker push ${IMAGE}:${TAG}"
            }
            sh "kubectl apply -f k8s/deployment.yaml"
            sh "kubectl apply -f k8s/service.yaml"
          } else {
            echo "Not release day, skipping deploy"
          }
        }
      }
    }
  }
}
