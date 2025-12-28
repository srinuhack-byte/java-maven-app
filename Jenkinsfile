pipeline {
    agent any

    environment {
        IMAGE_NAME = "srinu/demo-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/srinuhack-byte/java-maven-app.git',
                    credentialsId: 'githubsecond-token'
            }
        }

        stage('Build with Maven') {
            steps {
                // Run Maven inside a container but from shell
                sh "docker run --rm -v $PWD:/app -w /app maven:3.9.6-eclipse-temurin-11 mvn clean package"
            }
        }

        stage('Docker Build & Push') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }
    }
}
