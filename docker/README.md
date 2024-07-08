# Docker

### Usage

##### Show Version

```cmd
docker --version
```

##### Show Information

```cmd
docker system info
```

##### List Images

```cmd
docker image ls -a --no-trunc
```

```cmd
docker image ls -aq
```

```cmd
docker image ls -aqf "dangling=true"
```

##### Delete Unused Images

```cmd
docker image prune -f
```

##### List Containers

```cmd
docker container ls -a --no-trunc
```

```cmd
docker container ls -aq
```

```cmd
docker container ls -af "exited=0"
```

##### List Windows Credentials

```cmd
"C:\Program Files\Docker\Docker\resources\bin\docker-credential-wincred.exe" list
```

##### Add Windows Credentials

```cmd
echo {"ServerURL":"[Registry Endpoint]","Username":"[Username]","Secret":"[Secret]"} | "C:\Program Files\Docker\Docker\resources\bin\docker-credential-wincred.exe" store
```

##### Show Windows Credential

```cmd
echo [Registry Endpoint] | "C:\Program Files\Docker\Docker\resources\bin\docker-credential-wincred.exe" get
```

##### Remove Windows Credential

```cmd
echo [Registry Endpoint] | "C:\Program Files\Docker\Docker\resources\bin\docker-credential-wincred.exe" erase
```

### Rerferences

[Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/)
