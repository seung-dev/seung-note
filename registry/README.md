# registry

### Usage

##### catalog

```cmd
curl -k https://127.0.0.1:18579/v2/_catalog
```

##### tags

```cmd
curl -k https://127.0.0.1:18579/v2/[name]/tags/list
```

##### manifests

```cmd
curl -k https://127.0.0.1:18579/v2/[name]/manifests/[version]
```

##### digest

```cmd
curl -k -sS -o nul -w "%header{Docker-Content-Digest}" -H "Accept: application/vnd.docker.distribution.manifest.v2+json" https://127.0.0.1:18579/v2/[name]/manifests/[version]
```

##### delete

```cmd
curl -k -X DELETE https://127.0.0.1:18579/v2/[name]/manifests/[digest]
```

##### vacuum

```cmd
for /f %a in ('docker container -aqf "name=registry"') do (docker container exec -it %a registry garbage-collect -m /etc/docker/registry/config.yml)
```

### Run

```cmd
docker compose -f docker-compose.yaml up -d
```

> [!NOTE]
> Generate Self Signed Certificate(https://hub.docker.com/_/registry) for TLS

### References

[Docker Hub - registry](https://hub.docker.com/_/registry)
