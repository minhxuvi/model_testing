pipeline {
    agent {
        kubernetes {
            // Use the kubernetes config you created in Jenkins
            yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
  - name: python
    image: python:3.11-slim
    command:
    - cat
    tty: true
    readinessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 5
    lifecycle:
      postStart:
        exec:
          command:
          - /bin/sh
          - -c
          - touch /tmp/healthy
"""
            // Increase pod template timeout
            podRetention never()
            activeDeadlineSeconds 1200
            idleMinutes 5
        }
    }

    options {
        timeout(time: 20, unit: 'MINUTES')
        retry(3)
    }

    stages {
        stage('Wait for Pod') {
            steps {
                script {
                    // Wait a bit for pod to be fully ready
                    sleep(time: 30, unit: 'SECONDS')
                }
            }
        }

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