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
        PACKAGE_NAME = "task2-node-app-${BUILD_NUMBER}.tar.gz"
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
                    echo "Environment: $NODE_ENV"
                    echo "Build number: $BUILD_NUMBER"
                    echo "Workspace: $WORKSPACE"
                '''
            }
        }

        stage('Use Secret Safely') {
            steps {
                withCredentials([string(credentialsId: 'MY_SECRET_TOKEN', variable: 'TOKEN')]) {
                    sh '''
                        echo "Secret was loaded successfully"
                        echo "Secret length:"
                        echo "$TOKEN" | wc -c
                    '''
                }
            }
        }
	stage('Use Username Password Credential') {
 	   steps {
       		 withCredentials([usernamePassword(
           		 credentialsId: 'TEST_USERNAME_PASSWORD',
            		 usernameVariable: 'MY_USERNAME',
            		 passwordVariable: 'MY_PASSWORD'
        		)]) {
            			sh '''
                		echo "Username credential loaded:"
                		echo "$MY_USERNAME"

                		echo "Password is hidden. Password length:"
                		echo "$MY_PASSWORD" | wc -c
            		'''
        		}
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

        stage('Create Build Artifact') {
            steps {
                sh '''
                    mkdir -p dist

                    echo "App name: $APP_NAME" > dist/build-info.txt
                    echo "Build number: $BUILD_NUMBER" >> dist/build-info.txt
                    echo "Environment: $NODE_ENV" >> dist/build-info.txt
                    echo "Build date: $(date)" >> dist/build-info.txt

                    tar -czf dist/$PACKAGE_NAME app.js package.json test.js Jenkinsfile

                    ls -lah dist
                '''
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'dist/**', fingerprint: true
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
