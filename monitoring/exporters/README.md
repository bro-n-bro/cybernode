# Simplify setup of various exporter tools

Here you may find some automated tooling to install `Prometheus`, `node_exporter` and `cadvisor`.

To install all in one move run:

```bash
./install_exporters.sh
```

In order to change ports for exporter's to run on, modify .service files and `prometheus.yml`.