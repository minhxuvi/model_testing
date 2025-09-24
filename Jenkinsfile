pipeline {
    agent any
    stages {
        stage('Run Application') {
            steps {
                sh 'curl -LsSf https://astral.sh/uv/install.sh | sh'
                sh 'uv run main.py'
            }
        }
    }
}