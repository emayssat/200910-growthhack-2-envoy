FROM gcr.io/spiffe-io/spire-server:0.10.0

# Override spire configurations
COPY etc/spire-server.conf /opt/spire/conf/server/server.conf
COPY etc/agent-cacert.pem /opt/spire/conf/server/agent-cacert.pem

WORKDIR /opt/spire
