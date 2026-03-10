#!/usr/bin/env bash
set -euo pipefail

echo "=== Insights Agent Status ==="
kubectl get pods -n postman-insights-namespace

echo ""
echo "=== Recent Logs ==="
POD=$(kubectl get pods -n postman-insights-namespace -o jsonpath='{.items[0].metadata.name}')
kubectl logs -n postman-insights-namespace "$POD" --tail=30

echo ""
echo "=== Upload Status ==="
kubectl logs -n postman-insights-namespace "$POD" --tail=100 | \
  grep -E "(Uploaded|ERROR|WARNING|onboarding|403)" | tail -10
