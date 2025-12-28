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
                script {
                    // Use Maven Docker container to build the project
                    docker.image('maven:3.9.6-eclipse-temurin-11').inside('-v /var/run/docker.sock:/var/run/docker.sock') {
                        sh 'mvn clean package'
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Push') {
            steps {
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

    post {
        always {
            echo 'Cleaning up leftover Docker containers/images...'
            sh 'docker system prune -f'
        }

        success {
            echo "Pipeline completed successfully! Image pushed: ${IMAGE_NAME}:${IMAGE_TAG}"
        }

        failure {
            echo "Pipeline failed. Check the logs above."
        }
    }
}
