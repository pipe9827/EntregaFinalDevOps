pipeline {
    agent any
    options {disableConcurrentBuilds()}
    environment {
        GOOGLE_PROJECT_ID = "lab3-kubernetes-devops" 
        GOOGLE_PROJECT_NAME = "lab3-kubernetes-devops"
        GOOGLE_APPLICATION_CREDENTIALS = credentials('service-account-visitor')
        GOOGLE_CLOUD_KEYFILE_JSON = credentials('service-account-visitor')
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
                    $GCLOUD_PATH/gcloud compute networks list
                    '''
                }
            } //steps
        }  //stage
    
      
   }  // stages
} //pipeline
