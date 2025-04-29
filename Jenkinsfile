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
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Microservices') {
            parallel {
                stage('Config Server') {
                    steps {
                        dir('configserver') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Eureka Server') {
                    steps {
                        dir('eurekaserver') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Gateway Server') {
                    steps {
                        dir('gatewayserver') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Accounts') {
                    steps {
                        dir('accounts') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Cards') {
                    steps {
                        dir('cards') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Loans') {
                    steps {
                        dir('loans') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
            }
        }

        stage('Build and Push Docker Images') {
            steps {
                script {
                    def safeDockerPush = { imageName ->
                        int maxRetries = 3
                        int retryDelaySeconds = 10
                        int attempt = 1

                        while (attempt <= maxRetries) {
                            echo "🔄 Intento ${attempt} para subir ${imageName}"
                            def result = sh(script: "docker push ${imageName}", returnStatus: true)
                            
                            if (result == 0) {
                                echo "✅ Imagen ${imageName} subida correctamente en el intento ${attempt}"
                                break
                            } else {
                                echo "⚠️ Falló el push de ${imageName} (intento ${attempt})"
                                if (attempt == maxRetries) {
                                    error "❌ No se pudo subir ${imageName} después de ${maxRetries} intentos"
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
                            'cardsss': 'cards-service',
                            'loans': 'loans-service'
                        ]

                        parallel services.collectEntries { dirName, dockerName ->
                            ["${dirName}" : {
                                dir(dirName) {
                                    def imageName = "jbelzeboss97/${dockerName}:${DOCKER_IMAGE_VERSION}"

                                    sh """
                                        echo ">> Construyendo imagen ${imageName}"
                                        docker build --platform linux/amd64 -t ${imageName} .
                                    """

                                    def exists = sh(
                                        script: "curl --silent -f -lSL https://hub.docker.com/v2/repositories/jbelzeboss97/${dockerName}/tags/${DOCKER_IMAGE_VERSION}/ > /dev/null && echo true || echo false",
                                        returnStdout: true
                                    ).trim()

                                    if (exists == "false") {
                                        safeDockerPush(imageName)
                                    } else {
                                        echo ">> La imagen ${imageName} ya existe, omitiendo push"
                                    }
                                }
                            }]
                        }

                        sh 'docker logout'
                    }
                }
            }
        }


        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    def services = [
                        'configserver': 'configserver',
                        'eurekaserver': 'eurekaserver',
                        'gatewayserver': 'gatewayserver',
                        'accounts': 'accounts-service',
                        'cards': 'cards-service',
                        'loans': 'loans-service'
                    ]
                    services.each { dirName, dockerName ->
                        sh """
                            sed -i 's|jbelzeboss97/${dockerName}:[^ ]*|jbelzeboss97/${dockerName}:${DOCKER_IMAGE_VERSION}|' k8s/${dirName}/deployment.yaml
                        """
                    }
                }
            }
        }

        stage('Deploy to GKE') {
            steps {
                withCredentials([file(credentialsId: 'gcp-credentials', variable: 'GCP_KEY')]) {
                    script {
                        sh '''
                            gcloud auth activate-service-account --key-file=$GCP_KEY
                            gcloud container clusters get-credentials $CLUSTER_NAME --zone $LOCATION --project $PROJECT_ID

                            kubectl apply -f k8s/configmap.yaml

                            for service in configserver eurekaserver gatewayserver accounts loans cards; do
                                kubectl apply -f k8s/$service/deployment.yaml
                                kubectl apply -f k8s/$service/service.yaml
                            done
                        '''
                    }
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