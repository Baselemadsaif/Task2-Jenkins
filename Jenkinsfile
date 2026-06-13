pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Choose target environment')
        booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Run npm tests?')
        booleanParam(name: 'SHOW_FILES', defaultValue: true, description: 'Show files in workspace?')
    }

    environment {
        APP_NAME = 'task2-node-app'
        APP_PORT = '3000'
        NODE_ENV = "${params.ENVIRONMENT}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Show Build Info') {
            steps {
                echo "App name: ${env.APP_NAME}"
                echo "App port: ${env.APP_PORT}"
                echo "Selected environment: ${params.ENVIRONMENT}"
                echo "Run tests: ${params.RUN_TESTS}"
                echo "Show files: ${params.SHOW_FILES}"
                echo "Build number: ${env.BUILD_NUMBER}"
            }
        }

        stage('Inspect Files') {
            when {
                expression {
                    return params.SHOW_FILES
                }
            }
            steps {
                sh '''
                    echo "Workspace:"
                    pwd

                    echo "Files:"
                    ls -la
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            when {
                expression {
                    return params.RUN_TESTS
                }
            }
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
