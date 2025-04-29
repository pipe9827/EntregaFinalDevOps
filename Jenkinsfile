pipeline {
    agent any
    options {disableConcurrentBuilds()}
    environment {
        DOCKERHUB_CREDENTIALS = credentials('maikid3v-dockerhub')
        GOOGLE_PROJECT_ID = "lab3-kubernetes-devops" 
        GOOGLE_PROJECT_NAME = "lab3-kubernetes-devops"
        GOOGLE_APPLICATION_CREDENTIALS = credentials('service-account-visitor')
        GOOGLE_CLOUD_KEYFILE_JSON = credentials('service-account-visitor')
        LOCATION = 'us-central1'
        DOCKER_IMAGE_VERSION = "${BUILD_NUMBER}"

    }
    
    stages{
        
        stage('clean workspaces -----------') { 
            steps {
              cleanWs()
              sh 'env'
            } //steps
        }  //stage

        
        stage("Google Cloud connection -----------------"){
            steps {

                withEnv(['GCLOUD_PATH=/Users/maiki/Downloads/google-cloud-sdk/bin']) {
                    sh '$GCLOUD_PATH/gcloud --version'
                    sh("$GCLOUD_PATH/gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}")
                    sh '$GCLOUD_PATH/gcloud config set project ${GOOGLE_PROJECT_ID}'
                    sh '''
                    $GCLOUD_PATH/gcloud pubsub topics list
                    $GCLOUD_PATH/gcloud projects list
                    '''
                }
            } //steps
        }  //stage
    
        stage('Build and Push Docker Images') {
    steps {
        script {
            def safeDockerPush = { imageName ->
                int maxRetries = 3
                int retryDelaySeconds = 10
                int attempt = 1

                while (attempt <= maxRetries) {
                    echo " Attempt ${attempt} to push ${imageName}"
                    def result = sh(script: "docker push ${imageName}", returnStatus: true)
                    
                    if (result == 0) {
                        echo "Image ${imageName} pushed successfully on attempt ${attempt}"
                        break
                    } else {
                        echo "Failed to push ${imageName} (attempt ${attempt})"
                        if (attempt == maxRetries) {
                            error "Could not push ${imageName} after ${maxRetries} attempts"
                        }
                        sleep(time: retryDelaySeconds, unit: "SECONDS")
                        attempt++
                    }
                }
            }

            withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'

                def services = [
                    'configserver': 'configserver',
                    'eurekaserver': 'eurekaserver',
                    'gatewayserver': 'gatewayserver',
                    'accounts': 'accounts-service',
                    'cards': 'cards-service',
                    'loans': 'loans-service'
                ]

                parallel services.collectEntries { dirName, dockerName ->
                    ["${dirName}" : {
                        dir(dirName) {
                            def imageName = "jbelzeboss97/${dockerName}:${DOCKER_IMAGE_VERSION}"

                            sh """
                                echo ">> Building image ${imageName}"
                                docker build --platform linux/amd64 -t ${imageName} .
                            """

                            def exists = sh(
                                script: "curl --silent -f -lSL https://hub.docker.com/v2/repositories/jbelzeboss97/${dockerName}/tags/${DOCKER_IMAGE_VERSION}/ > /dev/null && echo true || echo false",
                                returnStdout: true
                            ).trim()

                            if (exists == "false") {
                                safeDockerPush(imageName)
                            } else {
                                echo ">> Image ${imageName} already exists, skipping push"
                            }
                        }
                    }]
                }

                sh 'docker logout'
            }
        }
    }
}
   }  // stages
} //pipeline
