pipeline {
    agent any
    stages {
        stage('Run Application') {
            environment {
                PATH = "/var/jenkins_home/.local/bin:${env.PATH}"
            }
            steps {
                sh 'uv run main.py'
            }
        }
    }
}