pipeline {
    agent any
    
    tools {
        maven 'Apache Maven 3.3.9'
        jdk 'jdk8'
    }
    stages {
        stage('Initialize') {
            steps {
                echo 'Initializing..'
                sh '''
                    echo "PATH=${PATH}"
                    echo "M@_HOME=${M2_HOME}"
                '''
            }
        }
        stage('Build') {
            steps {
                echo 'Building.123.'
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..123'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....123'
            }
        }
    }
}