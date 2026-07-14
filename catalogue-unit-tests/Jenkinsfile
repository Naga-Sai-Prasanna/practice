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
        // disableConcurrentBuilds()
        timeout(time: 5, unit: 'MINUTES')
    }

    /* parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
        text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')
        booleanParam(name: 'DEPLOY', defaultValue: false, description: 'Toggle this value')
        choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')
        password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
    } */

    stages {

        stage('Read version') {
            steps {
                dir('catalogue-unit-tests') {
                    script {
                        def packageJson = readJSON file: 'package.json'
                        appVersion = packageJson.version
                        echo "Building version ${appVersion}"
                    }
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('catalogue-unit-tests') {
                    script {
                        sh """
                            npm install
                        """
                    }
                }
            }
        }

        stage('Unit tests') {
            steps {
                dir('catalogue-unit-tests') {
                    script {
                        sh """
                            npm test
                        """
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('catalogue-unit-tests') {
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
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Image') {
            steps {
                dir('catalogue-unit-tests') {
                    script {
                        withAWS(credentials: 'aws-creds', region: "${region}") {
                            sh """
                                aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.${region}.amazonaws.com
                                docker build -t ${ACC_ID}.dkr.ecr.${region}.amazonaws.com/roboshop/catalogue:${appVersion} .
                                docker push ${ACC_ID}.dkr.ecr.${region}.amazonaws.com/roboshop/catalogue:${appVersion}
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'I will always say Hello again!'
            cleanWs()
        }
        success {
            echo "pipeline success"
        }
        failure {
            echo "pipeline failure"
        }
    }
}