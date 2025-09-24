# Getting Started

## Start the Ollama server

OLLAMA_HOST=0.0.0.0:11434 ollama serve &
or
brew services start ollama

## Start Jenkins

docker build -t model_testing_jenkins ./infrastructure/jenkins
export ADMIN_PASSWORD=admin123
docker run --name model_testing_jenkins -p 8080:8080 -p 50000:50000 -e ADMIN_PASSWORD=${ADMIN_PASSWORD} -v jenkins_home:/var/jenkins_home model_testing_jenkins &

## Deploy Jenkins to Kubernetes

docker build -t model_testing_jenkins:latest ./infrastructure/jenkins
kind load docker-image model_testing_jenkins:latest --name qa-cluster

kubectl apply -f ./infrastructure/jenkins/jenkins-k8s.yaml
or
kubectl rollout restart deployment/jenkins
kubectl rollout status deployment/jenkins

kubectl port-forward service/jenkins-service 8082:8080 &

## Build and deploy the QA app to Kubernetes

docker build -t qa-app:latest ./infrastructure/qa
kind load docker-image qa-app:latest --name qa-cluster
kubectl apply -f ./infrastructure/qa/deployment.yaml
or
kubectl rollout restart deployment/qa-app
kubectl port-forward service/qa-app-service 8081:80 &
curl "<http://localhost:8081/generate?prompt=hello>"
or
curl "<http://localhost:8081/health>"
