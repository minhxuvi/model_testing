# Start from the official Jenkins LTS image
FROM jenkins/jenkins:lts

# Switch to root to install additional packages
USER root

# Install kubectl, docker, and other necessary tools
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    && ARCH=$(dpkg --print-architecture) \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && KUBE_ARCH=$(case ${ARCH} in amd64) echo "amd64" ;; arm64) echo "arm64" ;; *) echo "amd64" ;; esac) \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${KUBE_ARCH}/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch back to jenkins user
USER jenkins

# Install Jenkins plugins including Kubernetes and Docker plugins
RUN jenkins-plugin-cli --plugins \
    git:latest \
    workflow-aggregator:latest \
    job-dsl:latest \
    kubernetes:latest \
    docker-workflow:latest \
    pipeline-stage-view:latest \
    blueocean:latest

# Skip complex CASC for now - we'll configure manually first