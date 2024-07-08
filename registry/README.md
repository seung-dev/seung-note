# registry

### Usage

##### Request catalog

```cmd
curl -k https://127.0.0.1:18579/v2/_catalog
```

##### Request tags

```cmd
curl -k https://127.0.0.1:18579/v2/[name]/tags/list
```

##### Request manifests

```cmd
curl -k https://127.0.0.1:18579/v2/[name]/manifests/[version]
```

##### Request digest

```cmd
curl -k -sS -o nul
  -w "%header{Docker-Content-Digest}"
  -H "Accept: application/vnd.docker.distribution.manifest.v2+json"
  https://127.0.0.1:18579/v2/[name]/manifests/[version]
```

##### Request delete

```cmd
curl -k -X DELETE https://127.0.0.1:18579/v2/[name]/manifests/[digest]
```

##### Run vacuum

```cmd
for /f %a in ('docker container ls -aqf "name=registry"') do (
  docker container exec -it %a registry garbage-collect -m /etc/docker/registry/config.yml
)
```

### Deploy with Docker & Docker Compose

```cmd
docker compose -f docker-compose.yaml up -d
```

> [!NOTE]
> [Generate Self Signed Certificate](https://github.com/seung-dev/seung-note/tree/main/misc#generate-self-signed-certificate) for TLS

### References

[Docker Hub - registry](https://hub.docker.com/_/registry)
