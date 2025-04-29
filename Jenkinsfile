pipeline {
    agent any
    options {disableConcurrentBuilds()}
    environment {
        DOCKERHUB_CREDENTIALS = credentials('maikid3v-dokerhub')
        GOOGLE_APPLICATION_CREDENTIALS = credentials('service-account-visitor')
        GOOGLE_CLOUD_KEYFILE_JSON = credentials('service-account-visitor')
        GOOGLE_PROJECT_ID = "lab3-kubernetes-devops" 
        GOOGLE_PROJECT_NAME = "lab3-kubernetes-devops"
        LOCATION = 'us-central1'
        DOCKER_IMAGE_VERSION = "${BUILD_NUMBER}"
        DOCKER_PATH="/usr/local/bin"
        GCLOUD_PATH="/Users/maiki/Downloads/google-cloud-sdk/bin"
    }
    
    stages {
        stage('Build Cards') {
            steps {
                script {
                    def dockerImage = "maikid3v/cards:${DOCKER_IMAGE_VERSION}"
                    sh """
                    echo ">> Construyendo imagen ${dockerImage}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${dockerImage} cards/.
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}