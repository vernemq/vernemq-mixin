# VerneMQ Monitoring Mixin

A set of Grafana dashboards and Prometheus alerts for VerneMQ

Note: Work in Progress

## How to use


This mixin is designed to be vendored into the repo with your infrastructure config.
To do this, use [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler):

You then have three options for deploying your dashboards
1. Generate the config files and deploy them yourself
2. Use the Kubernetes prometheus-operator to deploy this mixin

To use this project: 

1. Build JSonnet:
```sh
git clone git://github.com/google/jsonnet
cd jsonnet
make
./jsonnet
```

2. Install Jsonnet-bundler:
```sh
GO111MODULE="on" go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb\n
```

3. make the dashboards
```sh
make
```

This will create a dashboard_out directory, with 2 JSON files that you can import into your Grafana server.

Improvements welcome!
