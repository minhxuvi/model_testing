# Start from the official Jenkins LTS image
FROM jenkins/jenkins:lts

# Install the Configuration as Code plugin, git, pipeline plugins, Job DSL plugin, and Kubernetes plugin
RUN jenkins-plugin-cli --plugins \
    configuration-as-code:latest \
    git:latest \
    workflow-aggregator:latest \
    kubernetes:latest \
    kubernetes-credentials-provider:latest

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Add the UV binary directory to the PATH
ENV PATH="/var/jenkins_home/.local/bin:${PATH}"

# Copy your JCasC configuration file into the container
COPY jenkins.yaml /var/jenkins_home/jenkins.yaml

# Set the environment variable to tell Jenkins where to find the config file
# ENV CASC_JENKINS_CONFIG=/var/jenkins_home/jenkins.yaml