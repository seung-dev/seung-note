# Misc

### Useful Online Services

- Markdown
  - [GitHub](https://docs.github.com/ko/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
  - [GitLab](https://handbook.gitlab.com/docs/markdown-guide/)
- Converter
  - [Converter - Bundle](https://conv.darkbyte.ru/)
  - [Converter - EUC-KR Hex](https://r12a.github.io/app-encodings/)
- Network
  - [CIDR](https://mxtoolbox.com/subnetcalculator.aspx)
- Visual Studio Code
  - [Project Manager](https://github.com/alefragnani/vscode-project-manager)
  - [EDR Editor](https://github.com/dineug/erd-editor)

### Regex

##### Match Password

| Regex                                          | Descrition                      |
| ---------------------------------------------- | ------------------------------- |
| ^(?!._ )(?=._[a-zA-Z])(?=._\d)(?=._\W).{8,16}$ | 영어 + 숫자 + 특수문자 8~16자리 |

### OpenSSL

##### Generate Self Signed Certificate

```cmd
cd %UserProfile%
```

```cmd
mkdir .ssl
```

```cmd
cd .ssl
```

```cmd
openssl genrsa -out 127.0.0.1.key 4096
```

```cmd
openssl req -new -x509 -key 127.0.0.1.key -out 127.0.0.1.crt -days 3650 -subj "/C=KR/ST=Seoul/O=seung/CN=127.0.0.1/emailAddress=seung.dev@gmail.com" -addext "subjectAltName=IP:127.0.0.1" -text
```

```cmd
type 127.0.0.1.crt
```

##### Add Self Signed Certificate to Trusted Root Certificate Store

```cmd
certutil -addstore Root %UserProfile%\.ssl\127.0.0.1.crt
```

> [!NOTE]
> Use [Administrator: Command Prompt]

### Windows

##### Add System Path

```cmd
mkdir %UserProfile%\.seung\bin
```

```cmd
setx SEUNG_PATH %UserProfile%\.seung
```

```cmd
setx PATH "%PATH%;%SEUNG_PATH%\bin"
```

> [!NOTE]
> Use [Administrator: Command Prompt]
