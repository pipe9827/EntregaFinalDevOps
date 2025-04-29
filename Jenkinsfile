pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building the application...'
                // Add build commands here, for example:
                // sh 'mvn clean package'
                // or
                // sh 'npm install'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                // Add test commands here, for example:
                // sh 'mvn test'
                // or
                // sh 'npm test'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying the application...'
                // Add deployment commands here
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}