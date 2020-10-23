FROM gcr.io/spiffe-io/spire-agent:0.10.0 as spire

FROM envoyproxy/envoy-alpine:v1.14.1
RUN mkdir -p /opt/spire/conf/agent
RUN mkdir -p /opt/spire/data/agent
COPY --from=spire /opt/spire/bin/spire-agent /opt/spire/bin/spire-agent
COPY etc/envoy.yaml /etc/envoy/envoy.yaml
COPY etc/agent.conf /opt/spire/conf/agent/agent.conf
COPY etc/agent.key.pem /opt/spire/conf/agent/agent.key.pem
COPY etc/agent.crt.pem /opt/spire/conf/agent/agent.crt.pem
COPY bin/echo-server /usr/local/bin/echo-server

WORKDIR /opt/spire
# CMD /usr/local/bin/envoy -l debug -c /etc/envoy/envoy.yaml --log-path /tmp/envoy.log
ENTRYPOINT ["/bin/sleep"]
CMD ["infinity"]
