pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Inspect Files') {
            steps {
                sh 'pwd'
                sh 'ls -la'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }

        success {
            echo 'Pipeline succeeded'
        }

        failure {
            echo 'Pipeline failed. Check Console Output.'
        }
    }
}
