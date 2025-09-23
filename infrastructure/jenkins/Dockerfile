# Start from the official Jenkins LTS image
FROM jenkins/jenkins:lts

# Install the Configuration as Code plugin and any other plugins you need
RUN jenkins-plugin-cli --plugins configuration-as-code:latest git:latest

# Copy your JCasC configuration file into the container
COPY jenkins.yaml /var/jenkins_home/jenkins.yaml

# Set the environment variable to tell Jenkins where to find the config file
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/jenkins.yaml