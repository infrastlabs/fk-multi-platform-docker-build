#!/bin/bash
# https://docs.docker.com/engine/security/certificates/
# /etc/docker/certs.d/        <-- Certificate directory
# └── localhost:5000          <-- Hostname:port
#     ├── client.cert          <-- Client certificate
#     ├── client.key           <-- Client key
#     └── ca.crt               <-- Root CA that signed the registry certificate, in PEM

echo 172.25.20.161 test.registry.ssl |sudo tee -a /etc/hosts

# server.k8s.local:18443
certDir=/etc/docker/certs.d/test.registry.ssl:8143
mkdir -p $certDir
# 1.ok with 1.18.06; err with 1.10.3@barge
# 2.ctd still used.
# 3.openssl 1000年, cfssl 27x年;
cat <<EOF |sudo tee $certDir/cert.crt
-----BEGIN CERTIFICATE-----
MIICrjCCAZagAwIBAgIJAJeNn8hPcS4mMA0GCSqGSIb3DQEBCwUAMBkxFzAVBgNV
BAMMDmV4YW1wbGUuY2EuY29tMCAXDTIyMDYzMDA3NTUxNloYDzMwMjExMDMxMDc1
NTE2WjB0MQswCQYDVQQGEwJDTjEQMA4GA1UECAwHQmVpamluZzEQMA4GA1UEBwwH
QmVpamluZzEUMBIGA1UECgwLVW5pdGVkU3RhY2sxDzANBgNVBAsMBkRldm9wczEa
MBgGA1UEAwwRdGVzdC5yZWdpc3RyeS5zc2wwgZ8wDQYJKoZIhvcNAQEBBQADgY0A
MIGJAoGBANIRb7V0AnnT5ZdYF9ZVwpJ8E6z9OsRkGFVNxUe3Mrz8FeaCodf/jOYe
Ta8T6V/P4T+YpQiFzJ2eo9ucYQZKebLAaLC9qqCgfpi8hfp6AGvgERhQDk2x7CsG
CJqHIhnfCt+jlGFuLB5ulZxJLywmnwDhWc8jfaqT2ujTTYF03ZLVAgMBAAGjIDAe
MBwGA1UdEQQVMBOCEXRlc3QucmVnaXN0cnkuc3NsMA0GCSqGSIb3DQEBCwUAA4IB
AQCz6jTeU2TSQXCeYMjEVkT9LxggcNOoXJvZ2PAz6G6ax7Yd+ZCDoVK8YjWXowo1
P4iRM1wVW+xE5chw8CTXtf3wa1f7eM+UQP8pbzZeQUna8qab9qGGDjtozQl9VrUp
qdqJtp0THqLqjkW8lDcU3kPQfooAIHO7wREdRDUqHgjVM/GMz5bI1UjNZAO4OWz9
bzgQhnb84gushexkqqc3GGN77b7k+iVolhIEb5THinhHR5aySOmRGHLH6urrUtl0
u2oUSKx/el8YwwKzTVzYjR0Koll5m6qjLHXwENvtyaPlWEMXBQkS+RpGi43kUsKH
xbB11KXQg++jN11OsHgfxu0W
-----END CERTIFICATE-----
EOF

# 1.10.3@barge |k3s/registry/certs/$domain/ca-old-registry-docker-cli-used.pem
# cat > $certDir/ca.crt <<EOF
# -----BEGIN CERTIFICATE-----
# MIIDoDCCAoigAwIBAgIUa43H7NlaZjQ9/4qHByvM8m7WnKUwDQYJKoZIhvcNAQEL
# ...
# Nvx0e14hKLvaiUUcRJExVL0vVFM=
# -----END CERTIFICATE-----
# EOF

find /etc/docker/certs.d
md5sum $certDir/cert.crt

# login
echo admin123 |docker login test.registry.ssl:8143 --username=admin --password-stdin