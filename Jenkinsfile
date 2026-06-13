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
            when {
                expression {
                    return params.SHOW_FILES
                }
            }
            steps {
                sh 'ls -la'
            }
        }

        stage('Install Dependencies') {
            steps {
                retry(2) {
                    sh 'npm install'
                }
            }
        }

        stage('Run Tests') {
            when {
                expression {
                    return params.RUN_TESTS
                }
            }
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    sh 'npm test'
                }
            }
        }

        stage('Dev Deploy Simulation') {
            when {
                expression {
                    return params.ENVIRONMENT == 'dev'
                }
            }
            steps {
                echo 'Deploying to DEV environment...'
                sh 'echo "DEV deployment simulated successfully"'
            }
        }

        stage('Staging Deploy Simulation') {
            when {
                expression {
                    return params.ENVIRONMENT == 'staging'
                }
            }
            steps {
                echo 'Deploying to STAGING environment...'
                sh 'echo "STAGING deployment simulated successfully"'
            }
        }

        stage('Production Safety Check') {
            when {
                expression {
                    return params.ENVIRONMENT == 'prod'
                }
            }
            steps {
                echo 'Production selected. Deployment requires manual approval.'
            }
        }

        stage('Approve Production Deploy') {
            when {
                expression {
                    return params.ENVIRONMENT == 'prod'
                }
            }
            steps {
                input message: 'Approve deployment to production?', ok: 'Deploy'
                echo 'Production deployment approved.'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }

        success {
            echo "Pipeline succeeded for ${params.ENVIRONMENT}"
        }

        failure {
            echo "Pipeline failed for ${params.ENVIRONMENT}"
        }

        aborted {
            echo "Pipeline was aborted."
        }
    }
}
