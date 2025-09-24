# Getting Started

## Start the Ollama server

OLLAMA_HOST=0.0.0.0:11434 ollama serve &
or
brew services start ollama

## Start Jenkins

docker build -t model_testing_jenkins ./infrastructure/jenkins
export ADMIN_PASSWORD=admin123
docker run --name model_testing_jenkins -p 8080:8080 -p 50000:50000 -e ADMIN_PASSWORD=${ADMIN_PASSWORD} -v jenkins_home:/var/jenkins_home model_testing_jenkins &
