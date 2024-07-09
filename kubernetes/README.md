# Kubernetes

### Usage

##### List pods

```cmd
kubectl --kubeconfig [Config File] get pods -o wide
```

##### List Registry Credentials

```cmd
kubectl --kubeconfig [Config File] get secrets
```

##### Add Registry Credential

```cmd
kubectl --kubeconfig [Config File] create secret docker-registry [Credential Name] --docker-server=[Registry Endpoint] --docker-username=[Username] --docker-passwowrd=[Password] --docker-email=[Email]
```

##### Show Registry Credential

```cmd
kubectl --kubeconfig [Config File] get secret [Credential Name] -o jsonpath={.data}
```

##### Delete Registry Credential

```cmd
kubectl --kubeconfig [Config File] delete secret [Credential Name]
```

### Naver Kubernetes Service

##### Generate Kubeconfig

```cmd
ncp-iam-authenticator create-kubeconfig --region [KR|SGN|JPN] --clusterUuid [Cluster UUID] --output kubeconfig.yaml
```
