pipeline {
    agent any
    options {disableConcurrentBuilds()}
    environment {
        DOCKERHUB_CREDENTIALS = credentials('maikid3v-dokerhub')
        GOOGLE_APPLICATION_CREDENTIALS = credentials('service-account-total-contro')
        GOOGLE_CLOUD_KEYFILE_JSON = credentials('service-account-total-contro')
        GOOGLE_PROJECT_ID = "lab3-kubernetes-devops" 
        GOOGLE_PROJECT_NAME = "lab3-kubernetes-devops"
        LOCATION = 'us-central1'
        CLUSTER_NAME = 'devops-toolkit-pulumi'
        DOCKER_IMAGE_VERSION = "${BUILD_NUMBER}"
        DOCKER_PATH="/usr/local/bin"
        GCLOUD_PATH="/Users/maiki/Downloads/google-cloud-sdk/bin"
        DOCKER_IMAGE_CONFIGSERVER = "maikid3v/configserver"
        DOCKER_IMAGE_EUREKASERVER = "maikid3v/eurekaserver"
        DOCKER_IMAGE_ACCOUNTS = "maikid3v/accounts"
        DOCKER_IMAGE_CARDS = "maikid3v/cards"
        DOCKER_IMAGE_LOANS = "maikid3v/loans"
        DOCKER_IMAGE_GATEWAYSERVER = "maikid3v/gatewayserver"
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
                    echo ">> Construyendo imagen ${DOCKER_IMAGE_CONFIGSERVER}:${DOCKER_IMAGE_VERSION}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${DOCKER_IMAGE_CONFIGSERVER}:${DOCKER_IMAGE_VERSION} configserver/.
                    """
                }
            }
        }

        stage('Push ConfigServer') {
            steps {
                script {
                    sh """
                    echo ">> Subiendo imagen ${DOCKER_IMAGE_CONFIGSERVER}:${DOCKER_IMAGE_VERSION}"
                    $DOCKER_PATH/docker push ${DOCKER_IMAGE_CONFIGSERVER}:${DOCKER_IMAGE_VERSION}
                    """
                }
            }
        }

        stage('Build EurekaServer') {
            steps {
                script {
                    sh """
                    echo ">> Construyendo imagen ${DOCKER_IMAGE_EUREKASERVER}:${DOCKER_IMAGE_VERSION}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${DOCKER_IMAGE_EUREKASERVER}:${DOCKER_IMAGE_VERSION} eurekaserver/.
                    """
                }
            }
        }


        stage('Push EurekaServer') {
            steps {
                script {
                    sh """
                    echo ">> Subiendo imagen ${DOCKER_IMAGE_EUREKASERVER}:${DOCKER_IMAGE_VERSION}"
                    $DOCKER_PATH/docker push ${DOCKER_IMAGE_EUREKASERVER}:${DOCKER_IMAGE_VERSION}
                    """
                }
            }
        }

        stage('Build Accounts') {
            steps {
                script {
                    sh """
                    echo ">> Construyendo imagen ${DOCKER_IMAGE_ACCOUNTS}:${DOCKER_IMAGE_VERSION}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${DOCKER_IMAGE_ACCOUNTS}:${DOCKER_IMAGE_VERSION} accounts/.
                    """
                }
            }
        }

        stage('Push Accounts') {
            steps {
                script {
                    sh """
                    echo ">> Subiendo imagen ${DOCKER_IMAGE_ACCOUNTS}:${DOCKER_IMAGE_VERSION}"
                    $DOCKER_PATH/docker push ${DOCKER_IMAGE_ACCOUNTS}:${DOCKER_IMAGE_VERSION}
                    """
                }
            }
        }

        stage('Build Cards') {
            steps {
                script {
                    sh """
                    echo ">> Construyendo imagen ${DOCKER_IMAGE_CARDS}:${DOCKER_IMAGE_VERSION}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${DOCKER_IMAGE_CARDS}:${DOCKER_IMAGE_VERSION} cards/.
                    """
                }
            }
        }

        stage('Push Cards') {
            steps {
                script {
                    sh """
                    echo ">> Subiendo imagen ${DOCKER_IMAGE_CARDS}:${DOCKER_IMAGE_VERSION}"
                    $DOCKER_PATH/docker push ${DOCKER_IMAGE_CARDS}:${DOCKER_IMAGE_VERSION}
                    """
                }
            }
        }

        stage('Build Loans') {
            steps {
                script {
                    sh """
                    echo ">> Construyendo imagen ${DOCKER_IMAGE_LOANS}:${DOCKER_IMAGE_VERSION}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${DOCKER_IMAGE_LOANS}:${DOCKER_IMAGE_VERSION} loans/.
                    """
                }
            }
        }

        stage('Push Loans') {
            steps {
                script {
                    sh """
                    echo ">> Subiendo imagen ${DOCKER_IMAGE_LOANS}:${DOCKER_IMAGE_VERSION}"
                    $DOCKER_PATH/docker push ${DOCKER_IMAGE_LOANS}:${DOCKER_IMAGE_VERSION}
                    """
                }
            }
        }

        stage('Build GatewayServer') {
            steps {
                script {
                    sh """
                    echo ">> Construyendo imagen ${DOCKER_IMAGE_GATEWAYSERVER}:${DOCKER_IMAGE_VERSION}"
                    $DOCKER_PATH/docker build --platform linux/amd64 -t ${DOCKER_IMAGE_GATEWAYSERVER}:${DOCKER_IMAGE_VERSION} gatewayserver/.
                    """
                }
            }
        }

        stage('Push GatewayServer') {
            steps {
                script {
                    sh """
                    echo ">> Subiendo imagen ${DOCKER_IMAGE_GATEWAYSERVER}:${DOCKER_IMAGE_VERSION}"
                    $DOCKER_PATH/docker push ${DOCKER_IMAGE_GATEWAYSERVER}:${DOCKER_IMAGE_VERSION}
                    """
                }
            }
        }

        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    echo ">> Actualizando los manifiestos de Kubernetes"
                    sh """
                    sed -i '' 's|${DOCKER_IMAGE_CONFIGSERVER}:[^ ]*|${DOCKER_IMAGE_CONFIGSERVER}:${DOCKER_IMAGE_VERSION}|' kubernetes/configserver/deployment.yml
                    sed -i '' 's|${DOCKER_IMAGE_EUREKASERVER}:[^ ]*|${DOCKER_IMAGE_EUREKASERVER}:${DOCKER_IMAGE_VERSION}|' kubernetes/eurekaserver/deployment.yml
                    sed -i '' 's|${DOCKER_IMAGE_ACCOUNTS}:[^ ]*|${DOCKER_IMAGE_ACCOUNTS}:${DOCKER_IMAGE_VERSION}|' kubernetes/accounts/deployment.yml
                    sed -i '' 's|${DOCKER_IMAGE_CARDS}:[^ ]*|${DOCKER_IMAGE_CARDS}:${DOCKER_IMAGE_VERSION}|' kubernetes/cards/deployment.yml
                    sed -i '' 's|${DOCKER_IMAGE_LOANS}:[^ ]*|${DOCKER_IMAGE_LOANS}:${DOCKER_IMAGE_VERSION}|' kubernetes/loans/deployment.yml
                    sed -i '' 's|${DOCKER_IMAGE_GATEWAYSERVER}:[^ ]*|${DOCKER_IMAGE_GATEWAYSERVER}:${DOCKER_IMAGE_VERSION}|' kubernetes/gatewayserver/deployment.yml
                    """
                }
            }
        }

        stage('Run gcloud') {
            steps {
                sh("$GCLOUD_PATH/gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}")
                sh '$GCLOUD_PATH/gcloud config set project ${GOOGLE_PROJECT_ID}'
                sh '''
                  $GCLOUD_PATH/gcloud pubsub topics list
                  $GCLOUD_PATH/gcloud projects list
                '''
            }
        }

        stage('Deploy to GKE') {
            steps {
                script {
                    sh '''
                    gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                    gcloud config set project $GOOGLE_PROJECT_ID
                    gcloud container clusters get-credentials $CLUSTER_NAME --zone $LOCATION
                    gcloud container clusters update $CLUSTER_NAME --enable-autoscaling --min-nodes=1 --max-nodes=5

                    kubectl apply -f kubernetes/configmap.yml

                    kubectl apply -f kubernetes/configserver/deployment.yml
                    kubectl apply -f kubernetes/configserver/service.yml

                    kubectl apply -f kubernetes/eurekaserver/deployment.yml
                    kubectl apply -f kubernetes/eurekaserver/service.yml

                    kubectl apply -f kubernetes/gatewayserver/deployment.yml
                    kubectl apply -f kubernetes/gatewayserver/service.yml

                    kubectl apply -f kubernetes/accounts/deployment.yml
                    kubectl apply -f kubernetes/accounts/service.yml

                    kubectl apply -f kubernetes/loans/deployment.yml
                    kubectl apply -f kubernetes/loans/service.yml

                    kubectl apply -f kubernetes/cards/deployment.yml
                    kubectl apply -f kubernetes/cards/service.yml
                    '''
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