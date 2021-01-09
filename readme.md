** Ship rbac-based Kubernetes logs to logz.io using a Fluentd DaemonSet via Terraform

Fluentd is an Open Source data collector that can be used to forward logs to Logz.io.

This implementation uses a Fluentd DaemonSet to collect Kubernetes logs and send them to Logz.io. The Kubernetes DaemonSet ensures that some or all nodes run a copy of a pod.

The logzio-k8s image comes pre-configured for Fluentd to gather all logs from the Kubernetes node environment and append the proper metadata to the logs.

This terraform module is developed based on https://docs.logz.io/shipping/log-sources/kubernetes.html

It is tested with AWS EKS v1.18 and Terraform v0.14.3