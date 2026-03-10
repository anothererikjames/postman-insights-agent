# Postman Insights Agent — acme-platform

Kubernetes deployment for the [Postman Insights Agent](https://learning.postman.com/docs/postman-live-insights/live-insights-overview/) on the `acme-platform` cluster.

## What this does

The Insights Agent runs as a DaemonSet and passively captures HTTP traffic between services in the cluster. It sends API usage telemetry to Postman — endpoint response times, error rates, and traffic patterns — which surfaces in the **API Catalog** under each service's **Endpoints** tab.

## Cluster: `acme-platform`

| Service | Namespace | Status |
|---------|-----------|--------|
| payments-api | default | monitored |
| inventory-api | default | monitored |
| orders-api | default | monitored |
| recommendations-api | default | monitored |

## Deploy

```bash
# Create the API key secret
kubectl create secret generic postman-agent-secrets \
  --namespace postman-insights-namespace \
  --from-literal=postman-api-key=<YOUR_POSTMAN_API_KEY>

# Deploy the agent
kubectl apply -f k8s/daemonset.yaml
```

## Files

```
k8s/
  daemonset.yaml     — DaemonSet + RBAC + Namespace
scripts/
  deploy.sh          — One-shot deploy script
  verify.sh          — Check agent health + upload status
```

## Requirements

- Kubernetes 1.24+
- containerd runtime (socket at `/var/run/containerd/containerd.sock`)
- Postman API key with Insights permissions
- Onboarding completed in Postman UI (app.postman.com → Insights)
