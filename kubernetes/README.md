# Kubernetes

### Usage

##### List Pods

```cmd
kubectl --kubeconfig [Configuration File] get pods -o wide
```

##### List Services

```cmd
kubectl --kubeconfig [Configuration File] get services -o wide
```

##### List Ingress

```cmd
kubectl --kubeconfig [Configuration File] get ingresses
```

##### Tail Log

```cmd
kubectl --kubeconfig [Configuration File] logs -l app=[Application Name] -f
```

```cmd
kubectl --kubeconfig [Configuration File] logs -l app=[Application Name]
```

```cmd
kubectl --kubeconfig [Configuration File] logs [Resource Name]
```

##### Describe Resources

```cmd
kubectl --kubeconfig [Configuration File] describe pod [Pod Name]
```

```cmd
kubectl --kubeconfig [Configuration File] describe service [Service Name]
```

```cmd
kubectl --kubeconfig [Configuration File] describe ingress [Ingress Name]
```

##### Edit Image Version

```cmd
kustomize edit set image [Application Name]=[Registry Host]:[Registry Port]/[Application Name]:[Application Version]
```

##### Apply Resources

```cmd
kubectl --kubeconfig [Configuration File] apply -f [Configuration File Name]
```

```cmd
kustomize build | kubectl --kubeconfig [Configuration File] apply -f -
```

##### Delete Resources

```cmd
kubectl --kubeconfig [Configuration File] delete -f [Configuration File Name]
```

##### List Registry Credentials

```cmd
kubectl --kubeconfig [Configuration File] get secrets
```

##### Add Registry Credential

```cmd
kubectl --kubeconfig [Configuration File] create secret docker-registry [Credential Name] --docker-server=[Registry Endpoint] --docker-username=[UserName] --docker-passwowrd=[Password] --docker-email=[Email]
```

##### Show Registry Credential

```cmd
kubectl --kubeconfig [Configuration File] get secret [Credential Name] -o jsonpath={.data}
```

##### Delete Registry Credential

```cmd
kubectl --kubeconfig [Configuration File] delete secret [Credential Name]
```

### Naver Kubernetes Service

##### Generate Kubeconfig

```cmd
ncp-iam-authenticator create-kubeconfig --region [KR|SGN|JPN] --clusterUuid [Cluster UUID] --output kubeconfig.yaml
```
