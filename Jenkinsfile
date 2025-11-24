pipeline {
  agent any

  environment {
    IMAGE_NAME = "YOUR_DOCKERHUB_USERNAME/website"
    IMAGE_TAG  = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
      }
    }

    stage('Test') {
      steps {
        echo "Running simple tests"
        sh '''
          if [ -f index.html ]; then
            echo "index.html exists"
          else
            echo "index.html missing"; exit 1
          fi
        '''
      }
    }

    stage('Push to Registry (prod)') {
      when {
        branch 'master'
      }
      steps {
        echo "Pushing image to DockerHub"
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh '''
            echo "$PASS" | docker login -u "$USER" --password-stdin
            docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
            docker push ${IMAGE_NAME}:${IMAGE_TAG}
            docker push ${IMAGE_NAME}:latest
          '''
        }
      }
    }
  }
}
