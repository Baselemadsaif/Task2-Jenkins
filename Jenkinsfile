pipeline {
    agent any

    environment {
        APP_NAME = 'task2-node-app'
        APP_PORT = '3000'
        NODE_ENV = 'development'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Show Environment') {
            steps {
                sh '''
                    echo "App name: $APP_NAME"
                    echo "App port: $APP_PORT"
                    echo "Node environment: $NODE_ENV"
                    echo "Build number: $BUILD_NUMBER"
                    echo "Job name: $JOB_NAME"
                    echo "Workspace: $WORKSPACE"
                '''
            }
        }

        stage('Inspect Files') {
            steps {
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
