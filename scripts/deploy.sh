#!/usr/bin/env bash
set -euo pipefail

POSTMAN_API_KEY="${POSTMAN_API_KEY:-}"
if [ -z "$POSTMAN_API_KEY" ]; then
  echo "ERROR: Set POSTMAN_API_KEY environment variable"
  exit 1
fi

echo "→ Creating namespace and secrets..."
kubectl create namespace postman-insights-namespace --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic postman-agent-secrets \
  --namespace postman-insights-namespace \
  --from-literal=postman-api-key="$POSTMAN_API_KEY" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "→ Deploying Insights Agent DaemonSet..."
kubectl apply -f k8s/daemonset.yaml

echo "→ Waiting for rollout..."
kubectl rollout status daemonset/postman-insights-agent \
  -n postman-insights-namespace --timeout=120s

echo "✓ Agent deployed. Cluster: acme-platform"
echo "  Next: complete onboarding at app.postman.com → Insights"
