# Docker

### Usage

##### Version

```cmd
docker --version
```

##### Information

```cmd
docker info
```

##### Images

```cmd
docker image ls -a --no-trunc
```

```cmd
docker image ls -aq
```

```cmd
docker image ls -aqf "dangling=true"
```

##### Containers

```cmd
docker container ls -a --no-trunc
```

```cmd
docker container ls -aq
```

```cmd
docker container ls -af "exited=0"
```

### Rerferences

[Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/)
