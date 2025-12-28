pipeline {
    agent {
        docker {
            image 'maven:3.9.6-eclipse-temurin-11'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        IMAGE_NAME = "srinu/demo-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        // SONAR_HOST = "http://<SONAR_IP>:9000"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/yourname/java-maven-app.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
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
                    sh """
                    echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }

        /*
        stage('Update K8s Manifests') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GIT_TOKEN')]) {
                    sh """
                    git clone https://\$GIT_TOKEN@github.com/yourname/k8s-manifests.git
                    cd k8s-manifests
                    sed -i 's|image:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|' deployment.yaml
                    git add .
                    git commit -m "Update image to ${IMAGE_TAG}"
                    git push origin main
                    """
                }
            }
        }
        */
    }
}
