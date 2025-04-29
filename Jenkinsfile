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
        DOCKER_IMAGE_CONFIGSERVER = "maikid3v/configserver:${DOCKER_IMAGE_VERSION}"
        DOCKER_IMAGE_EUREKASERVER = "maikid3v/eurekaserver:${DOCKER_IMAGE_VERSION}"
        DOCKER_IMAGE_ACCOUNTS = "maikid3v/accounts:${DOCKER_IMAGE_VERSION}"
        DOCKER_IMAGE_CARDS = "maikid3v/cards:${DOCKER_IMAGE_VERSION}"
        DOCKER_IMAGE_LOANS = "maikid3v/loans:${DOCKER_IMAGE_VERSION}"
        DOCKER_IMAGE_GATEWAYSERVER = "maikid3v/gatewayserver:${DOCKER_IMAGE_VERSION}"
    }
    
    stages {
        stage('Login') {
            steps {
                script {
                    echo ">> Iniciando sesión en DockerHub"
                    sh """
                    $DOCKER_PATH/docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW}
                    """
                }
            }
        }

        stage('Build ConfigServer') {
            steps {
                script {
                    sh """
                    echo ">> Construyendo imagen ${DOCKER_IMAGE_CONFIGSERVER}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${DOCKER_IMAGE_CONFIGSERVER} configserver/.
                    """
                }
            }
        }

        stage('Push ConfigServer') {
            steps {
                script {
                    sh """
                    echo ">> Subiendo imagen ${DOCKER_IMAGE_CONFIGSERVER}"
                    $DOCKER_PATH/docker push ${DOCKER_IMAGE_CONFIGSERVER}
                    """
                }
            }
        }

        stage('Build EurekaServer') {
            steps {
                script {
                    sh """
                    echo ">> Construyendo imagen ${DOCKER_IMAGE_EUREKASERVER}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${DOCKER_IMAGE_EUREKASERVER} eurekaserver/.
                    """
                }
            }
        }


        stage('Push EurekaServer') {
            steps {
                script {
                    sh """
                    echo ">> Subiendo imagen ${DOCKER_IMAGE_EUREKASERVER}"
                    $DOCKER_PATH/docker push ${DOCKER_IMAGE_EUREKASERVER}
                    """
                }
            }
        }

        stage('Build Accounts') {
            steps {
                script {
                    sh """
                    echo ">> Construyendo imagen ${DOCKER_IMAGE_ACCOUNTS}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${DOCKER_IMAGE_ACCOUNTS} accounts/.
                    """
                }
            }
        }

        stage('Push Accounts') {
            steps {
                script {
                    sh """
                    echo ">> Subiendo imagen ${DOCKER_IMAGE_ACCOUNTS}"
                    $DOCKER_PATH/docker push ${DOCKER_IMAGE_ACCOUNTS}
                    """
                }
            }
        }

        stage('Build Cards') {
            steps {
                script {
                    sh """
                    echo ">> Construyendo imagen ${DOCKER_IMAGE_CARDS}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${DOCKER_IMAGE_CARDS} cards/.
                    """
                }
            }
        }

        stage('Push Cards') {
            steps {
                script {
                    sh """
                    echo ">> Subiendo imagen ${DOCKER_IMAGE_CARDS}"
                    $DOCKER_PATH/docker push ${DOCKER_IMAGE_CARDS}
                    """
                }
            }
        }

        stage('Build Loans') {
            steps {
                script {
                    sh """
                    echo ">> Construyendo imagen ${DOCKER_IMAGE_LOANS}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${DOCKER_IMAGE_LOANS} loans/.
                    """
                }
            }
        }

        stage('Push Loans') {
            steps {
                script {
                    sh """
                    echo ">> Subiendo imagen ${DOCKER_IMAGE_LOANS}"
                    $DOCKER_PATH/docker push ${DOCKER_IMAGE_LOANS}
                    """
                }
            }
        }

        stage('Build GatewayServer') {
            steps {
                script {
                    sh """
                    echo ">> Construyendo imagen ${DOCKER_IMAGE_GATEWAYSERVER}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${DOCKER_IMAGE_GATEWAYSERVER} gatewayserver/.
                    """
                }
            }
        }

        stage('Push GatewayServer') {
            steps {
                script {
                    sh """
                    echo ">> Subiendo imagen ${DOCKER_IMAGE_GATEWAYSERVER}"
                    $DOCKER_PATH/docker push ${DOCKER_IMAGE_GATEWAYSERVER}
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