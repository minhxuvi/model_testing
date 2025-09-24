#!/bin/bash

# Kubernetes-Jenkins Integration Setup Script
# This script sets up Jenkins in your Kubernetes cluster with full CI/CD capabilities

set -e

echo "🚀 Setting up Kubernetes-Jenkins Integration..."

# Build custom Jenkins image
echo "📦 Building custom Jenkins image..."
cd infrastructure/jenkins
docker build -t jenkins-custom:latest -f dockerfile .
cd ../..

# Load Jenkins image to kind cluster
echo "📥 Loading Jenkins image to kind cluster..."
kind load docker-image jenkins-custom:latest --name model-testing

# Apply Kubernetes resources
echo "⚙️  Applying Kubernetes resources..."

# Create namespace if it doesn't exist
kubectl create namespace jenkins --dry-run=client -o yaml | kubectl apply -f -

# Apply RBAC
kubectl apply -f infrastructure/jenkins/jenkins-rbac.yaml

# Apply Jenkins deployment
kubectl apply -f infrastructure/jenkins/jenkins-deployment.yaml

# Wait for Jenkins to be ready
echo "⏳ Waiting for Jenkins to be ready..."
kubectl wait --for=condition=available deployment/jenkins --timeout=300s

# Get Jenkins URL
NODE_PORT=$(kubectl get service jenkins-service -o jsonpath='{.spec.ports[0].nodePort}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

echo ""
echo "✅ Jenkins setup complete!"
echo ""
echo "🔗 Access Jenkins at:"
echo "   http://localhost:${NODE_PORT} (if using port-forward)"
echo "   Or: kubectl port-forward service/jenkins-service 8080:8080"
echo ""
echo "🔑 Default credentials:"
echo "   Username: admin"
echo "   Password: admin123"
echo ""
echo "📋 Next steps:"
echo "1. Access Jenkins and configure your pipeline"
echo "2. Create a new Pipeline job pointing to your repository"
echo "3. The Jenkinsfile will handle building and deploying your model-testing app"
echo ""
echo "🎯 To test the pipeline:"
echo "   kubectl port-forward service/jenkins-service 8080:8080"
echo "   Open http://localhost:8080 in your browser"
echo ""

# Start port-forward for easy access
echo "🌐 Starting port-forward to Jenkins..."
kubectl port-forward service/jenkins-service 8080:8080 &
PORT_FORWARD_PID=$!

echo "Port-forward started (PID: $PORT_FORWARD_PID)"
echo "Press Ctrl+C to stop port-forward and exit"

# Wait for interrupt
trap "echo 'Stopping port-forward...'; kill $PORT_FORWARD_PID 2>/dev/null || true; exit 0" INT
wait $PORT_FORWARD_PID