pipeline {
    agent any

    environment {
        IMAGE_NAME = "srinu/demo-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        // SONAR_HOST = "http://<SONAR_IP>:9000"  // Uncomment if SonarQube is needed
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
            agent {
                docker {
                    image 'maven:3.9.6-eclipse-temurin-11'
                    args '-u 1000:1000' // Avoid permission issues with workspace
                }
            }
            steps {
                sh 'mvn clean package -B'
            }
        }

        /*
        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                    sh """
                    mvn sonar:sonar \
                        -Dsonar.projectKey=demo \
                        -Dsonar.host.url=${SONAR_HOST} \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }
        */

        stage('Docker Build & Push') {
            steps {
                // Build Docker image using host Docker
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."

                // Push to Docker Hub
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
            echo "Cleaning up Docker containers if any leftover..."
            sh "docker system prune -f"
        }
        success {
            echo "Pipeline completed successfully! Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "Pipeline failed. Check the logs for details."
        }
    }
}
