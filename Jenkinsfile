pipeline {
    agent any
    options {disableConcurrentBuilds()}
    environment {
        GOOGLE_PROJECT_ID = "ilab3-kubernetes-devops" 
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
                
                sh("gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}")
                sh 'gcloud config set project ${GOOGLE_PROJECT_ID}'
                sh '''
                  gcloud pubsub topics list
                  gcloud projects list
                  gcloud compute networks list
                '''
            } //steps
        }  //stage
    
      
   }  // stages
} //pipeline
