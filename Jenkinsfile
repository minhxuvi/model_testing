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
    env:
    - name: PYTHONUNBUFFERED
      value: "1"
    readinessProbe:
      exec:
        command: ["python3", "-c", "print('ready')"]
      initialDelaySeconds: 30
      periodSeconds: 5
      timeoutSeconds: 3
      failureThreshold: 3
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
        stage('Run Application') {
            steps {
                container('python') {
                    sh '''
                    python3 -c "
import urllib.request
import urllib.error

try:
    with urllib.request.urlopen('http://qa-app-service:80/health') as response:
        print(f'Status Code: {response.status}')
        print(f'Response: {response.read().decode()}')
except urllib.error.URLError as e:
    print(f'Error: {e}')
    exit(1)
"
                    '''
                }
            }
        }
    }
}