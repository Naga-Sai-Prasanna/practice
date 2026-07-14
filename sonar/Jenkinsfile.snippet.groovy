// Full corrected pipeline snippet — SonarQube Analysis stage wrapped in dir('catalogue')
// so sonar-scanner runs from the same folder as sonar-project.properties.
// Also switched to sonar.token (SONAR_TOKEN) instead of the deprecated sonar.login.

pipeline {
    agent {
        node {
            label 'roboshop'
        }
    }

    environment {
        appVersion = ""
        ACC_ID = "864981724645"
        region = "us-east-1"
    }

    options {
        timeout(time: 5, unit: 'MINUTES')
    }

    stages {
        stage('Read version') {
            steps {
                dir('catalogue') {
                    script {
                        def packageJson = readJSON file: 'package.json'
                        appVersion = packageJson.version
                        echo "Building version ${appVersion}"
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('catalogue') {
                    script {
                        def scannerHome = tool name: 'sonar-8'
                        withSonarQubeEnv('sonar-server') {
                            sh "${scannerHome}/bin/sonar-scanner"
                        }
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    // Waits for SonarQube to finish processing and checks the
                    // Quality Gate result created by the analysis above.
                    // abortPipeline: true fails the build automatically if the gate fails.
                    timeout(time: 3, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }

        stage('Build image') {
            steps {
                echo "Add your image build steps here"
            }
        }
    }
}
