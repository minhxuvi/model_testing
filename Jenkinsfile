pipeline {
    agent any
    stages {
        stage('Run Application') {
            environment {
                PATH = "/var/jenkins_home/.local/bin:${env.PATH}"
            }
            steps {
                sh 'curl -LsSf https://astral.sh/uv/install.sh | sh'
                sh 'uv run main.py'
            }
        }
    }
}