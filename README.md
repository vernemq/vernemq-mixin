# VerneMQ Monitoring Mixin

A set of Grafana dashboards and Prometheus alerts for VerneMQ

## How to use


This mixin is designed to be vendored into the repo with your infrastructure config.
To do this, use [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler):

You then have three options for deploying your dashboards
1. Generate the config files and deploy them yourself
2. Use the Kubernetes prometheus-operator to deploy this mixin


