pipeline {
    agent {
        kubernetes {
            // Use the kubernetes config you created in Jenkins
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: python
    image: python:3.11-slim
    command:
    - cat
    tty: true
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
"""
        }
    }
    stages {
        stage('Run Application') {
            steps {
                container('python') {
                    // Install uv if needed
                    sh 'curl -LsSf https://astral.sh/uv/install.sh | sh'
                    sh 'export PATH="$HOME/.local/bin:$PATH" && uv run main.py'
                }
            }
        }
    }
}