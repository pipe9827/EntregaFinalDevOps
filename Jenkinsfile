pipeline {
    agent any
    options {disableConcurrentBuilds()}
    environment {
        DOCKERHUB_CREDENTIALS = credentials('maikid3v-dokerhub')
        GOOGLE_PROJECT_ID = "lab3-kubernetes-devops" 
        GOOGLE_PROJECT_NAME = "lab3-kubernetes-devops"
        GOOGLE_APPLICATION_CREDENTIALS = credentials('service-account-visitor')
        GOOGLE_CLOUD_KEYFILE_JSON = credentials('service-account-visitor')
        LOCATION = 'us-central1'
        DOCKER_IMAGE_VERSION = "${BUILD_NUMBER}"
        DOCKER_PATH="/usr/local/bin"
        GCLOUD_PATH="/Users/maiki/Downloads/google-cloud-sdk/bin"
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

                sh '$GCLOUD_PATH/gcloud --version'
                sh("$GCLOUD_PATH/gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}")
                sh '$GCLOUD_PATH/gcloud config set project ${GOOGLE_PROJECT_ID}'
                sh '''
                $GCLOUD_PATH/gcloud pubsub topics list
                $GCLOUD_PATH/gcloud projects list
                '''
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
                            def result = sh(script: "$DOCKER_PATH/docker push ${imageName}", returnStatus: true)
                            
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

                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | $DOCKER_PATH/docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'

                    def services = [
                        'configserver': 'configserver',
                        'eurekaserver': 'eurekaserver',
                        'gatewayserver': 'gatewayserver',
                        'accounts': 'accounts',
                        'cards': 'cards',
                        'loans': 'loans'
                    ]

                    parallel services.collectEntries { dirName, dockerName ->
                        ["${dirName}" : {
                            dir(dirName) {
                                sh "ls -la"
                                def imageName = "maikid3v/${dockerName}:${DOCKER_IMAGE_VERSION}"
                                def exists = sh(
                                    script: "curl --silent -f -lSL https://hub.docker.com/repositories/maikid3v/${dockerName}/tags/${DOCKER_IMAGE_VERSION}/ > /dev/null && echo true || echo false",
                                    returnStdout: true
                                ).trim()

                                if (exists == "false") {
                                    sh """
                                    echo ">> Building image ${imageName}"
                                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${imageName} /.
                                    """
                                    safeDockerPush(imageName)
                                } else {
                                    echo ">> Image ${imageName} already exists, skipping push"
                                }
                            }
                        }]
                    }

                    sh '$DOCKER_PATH/docker logout'
                }
            }
        }
   }  // stages
} //pipeline
