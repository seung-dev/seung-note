# pwd
/root
# mkdir pki
# cd pki
# pwd
/root/pki
# openssl genrsa -aes256 -out rootca-seung.key 2048
Generating RSA private key, 2048 bit long modulus (2 primes)
.........................................+++++
..........................................................................................................+++++
e is 65537 (0x010001)
Enter pass phrase for rootca-seung.key:
Verifying - Enter pass phrase for rootca-seung.key:
# chmod 600 rootca-seung.key 
# vi rootca_seung.conf
# cat rootca_seung.conf 
[ req ]
default_bits       = 2048
default_md         = sha1
default_keyfile    = bigtech-rootca.key
distinguished_name = req_distinguished_name
extensions         = v3_ca
req_extensions     = v3_ca

[ v3_ca ]
basicConstraints         = critical, CA:TRUE, pathlen:0
subjectKeyIdentifier     = hash
##authorityKeyIdentifier = keyid:always, issuer:always
keyUsage                 = keyCertSign, cRLSign
nsCertType               = sslCA, emailCA, objCA

[req_distinguished_name ]
countryName                    = Country Name (2 letter code)
countryName_default            = KR
countryName_min                = 2
countryName_max                = 2

organizationName               = Organization name
organizationName_default       = seung

organizationalUnitName         = Organizational unit name
organizationalUnitName_default = dev lab

commonName                     = Common name
commonName_default             = seung Self Signed CA
commonName_max                 = 64

# openssl req -new -key rootca-seung.key -out rootca-seung.csr -config rootca-seung.conf
Enter pass phrase for rootca-seung.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [KR]:
Organization name [seung]:
Organizational unit name [dev lab]:
Common name [seung Self Signed CA]:
# ll
total 12
-rw-r--r--. 1 root root  972 Jul 12 04:27 rootca-seung.conf
-rw-r--r--. 1 root root 1106 Jul 12 04:28 rootca-seung.csr
-rw-------. 1 root root 1766 Jul 12 04:23 rootca-seung.key
# openssl x509 -req -days 3650 -extensions v3_ca -set_serial 1 -in rootca-seung.csr -signkey rootca-seung.key -out rootca-seung.crt -extfile rootca-seung.conf
Signature ok
subject=C = KR, O = seung, OU = dev lab, CN = seung Self Signed CA
Getting Private key
Enter pass phrase for rootca-seung.key:
# openssl x509 -text -in rootca-seung.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1 (0x1)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = KR, O = seung, OU = dev lab, CN = seung Self Signed CA
        Validity
            Not Before: Jul 12 11:33:17 2020 GMT
            Not After : Jul 10 11:33:17 2030 GMT
        Subject: C = KR, O = seung, OU = dev lab, CN = seung Self Signed CA
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:ca:2a:9f:81:a9:d0:01:53:e4:84:8e:ac:60:fb:
                    bb:00:55:90:54:8d:da:38:47:53:da:96:4e:e6:2e:
                    d7:13:6b:2c:59:a8:4c:8b:38:83:e8:85:d0:77:a9:
                    5a:ca:13:5b:34:02:a3:4a:a6:77:aa:78:90:6f:22:
                    41:e6:7e:23:3a:b3:9e:cf:c5:df:4d:aa:f4:c1:02:
                    82:02:3f:00:f6:be:e6:c8:e8:e7:b8:d2:e0:c0:29:
                    fe:8a:a9:b1:7b:43:f9:e0:21:c1:e8:3d:45:12:44:
                    39:ae:92:a2:e9:c6:6c:e7:f2:7c:a5:1c:14:02:9c:
                    21:d7:ca:f4:28:2b:aa:f0:7b:13:7a:90:6a:be:fd:
                    89:0d:5a:3f:a8:52:9f:e9:48:b9:f4:5a:66:e7:a3:
                    2e:74:6a:15:50:ef:6c:5e:00:2f:9f:37:43:03:27:
                    74:c5:d3:fb:c9:5e:23:0b:ce:8d:5e:d8:16:c5:62:
                    2d:e1:9d:51:af:49:5e:20:a6:9f:5e:ec:82:c3:4e:
                    6d:e1:3a:6c:01:33:c3:37:9a:46:00:c3:22:06:41:
                    05:b2:db:30:eb:bb:4f:ef:2b:9e:13:a1:b9:21:ce:
                    22:c9:00:83:49:d4:c1:80:b7:71:98:ad:0c:7f:54:
                    f5:17:ed:7a:19:95:c2:fb:ab:39:6c:21:da:bb:b0:
                    1f:81
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: critical
                CA:TRUE, pathlen:0
            X509v3 Subject Key Identifier: 
                F4:41:99:19:5D:B5:59:D6:4F:C3:40:72:4E:1B:94:33:55:50:A8:7D
            X509v3 Key Usage: 
                Certificate Sign, CRL Sign
            Netscape Cert Type: 
                SSL CA, S/MIME CA, Object Signing CA
    Signature Algorithm: sha256WithRSAEncryption
         5a:a1:56:3b:a8:eb:fd:ec:3e:6b:12:f4:57:79:e9:b7:de:77:
         84:74:c5:5b:70:20:cd:45:65:6c:28:1e:de:d8:a9:2c:b9:c5:
         a0:33:cd:5c:9e:a5:1b:9d:e4:14:99:ef:c4:99:d8:36:38:b1:
         3c:11:83:a9:07:a0:c1:86:5e:a3:1a:b2:30:ff:4e:49:d4:20:
         de:d9:5f:d3:c4:81:03:8e:82:ae:cb:9d:6c:27:6e:d5:2f:b7:
         75:a6:8d:78:d4:1d:49:72:8a:64:c6:c8:ac:18:e2:7a:4b:05:
         a1:da:86:df:61:2f:ed:ee:c2:cc:5b:18:11:4a:9c:8e:98:41:
         33:c7:77:96:66:d0:7a:04:e1:2b:b9:c7:6e:1c:ef:f9:28:ca:
         6b:2e:84:f5:eb:c2:a0:93:e3:47:77:76:13:22:8a:3c:37:5e:
         86:09:5a:80:b7:a7:16:35:06:51:0e:fb:19:24:f6:85:26:7a:
         f1:67:0d:cf:55:7d:01:bc:16:13:2e:bd:4a:82:34:f0:63:b0:
         5b:4a:a6:e9:f5:c9:41:9b:d0:11:2b:0b:8f:35:42:20:b0:0a:
         8e:16:0b:a3:4d:44:68:f8:e5:13:d1:46:fb:04:10:d9:10:80:
         c0:a2:51:60:03:bc:42:61:23:54:9e:ee:b0:f5:0a:3a:a1:0d:
         1d:39:64:9f
-----BEGIN CERTIFICATE-----
MIIDbDCCAlSgAwIBAgIBATANBgkqhkiG9w0BAQsFADBOMQswCQYDVQQGEwJLUjEO
MAwGA1UECgwFc2V1bmcxEDAOBgNVBAsMB2RldiBsYWIxHTAbBgNVBAMMFHNldW5n
IFNlbGYgU2lnbmVkIENBMB4XDTIwMDcxMjExMzMxN1oXDTMwMDcxMDExMzMxN1ow
TjELMAkGA1UEBhMCS1IxDjAMBgNVBAoMBXNldW5nMRAwDgYDVQQLDAdkZXYgbGFi
MR0wGwYDVQQDDBRzZXVuZyBTZWxmIFNpZ25lZCBDQTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAMoqn4Gp0AFT5ISOrGD7uwBVkFSN2jhHU9qWTuYu1xNr
LFmoTIs4g+iF0HepWsoTWzQCo0qmd6p4kG8iQeZ+Izqzns/F302q9MECggI/APa+
5sjo57jS4MAp/oqpsXtD+eAhweg9RRJEOa6SounGbOfyfKUcFAKcIdfK9CgrqvB7
E3qQar79iQ1aP6hSn+lIufRaZuejLnRqFVDvbF4AL583QwMndMXT+8leIwvOjV7Y
FsViLeGdUa9JXiCmn17sgsNObeE6bAEzwzeaRgDDIgZBBbLbMOu7T+8rnhOhuSHO
IskAg0nUwYC3cZitDH9U9RftehmVwvurOWwh2ruwH4ECAwEAAaNVMFMwEgYDVR0T
AQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQU9EGZGV21WdZPw0ByThuUM1VQqH0wCwYD
VR0PBAQDAgEGMBEGCWCGSAGG+EIBAQQEAwIABzANBgkqhkiG9w0BAQsFAAOCAQEA
WqFWO6jr/ew+axL0V3npt953hHTFW3AgzUVlbCge3tipLLnFoDPNXJ6lG53kFJnv
xJnYNjixPBGDqQegwYZeoxqyMP9OSdQg3tlf08SBA46CrsudbCdu1S+3daaNeNQd
SXKKZMbIrBjieksFodqG32Ev7e7CzFsYEUqcjphBM8d3lmbQegThK7nHbhzv+SjK
ay6E9evCoJPjR3d2EyKKPDdehglagLenFjUGUQ77GST2hSZ68WcNz1V9AbwWEy69
SoI08GOwW0qm6fXJQZvQESsLjzVCILAKjhYLo01EaPjlE9FG+wQQ2RCAwKJRYAO8
QmEjVJ7usPUKOqENHTlknw==
-----END CERTIFICATE-----
# openssl genrsa -aes256 -out seung-gitlab.key 2048
Generating RSA private key, 2048 bit long modulus (2 primes)
.........................+++++
..........................................+++++
e is 65537 (0x010001)
Enter pass phrase for seung-gitlab.key:
Verifying - Enter pass phrase for seung-gitlab.key:
# cp seung-gitlab.key seung-gitlab.key.enc
# ll
total 24
-rw-r--r--. 1 root root  972 Jul 12 04:27 rootca-seung.conf
-rw-r--r--. 1 root root 1249 Jul 12 04:33 rootca-seung.crt
-rw-r--r--. 1 root root 1106 Jul 12 04:28 rootca-seung.csr
-rw-------. 1 root root 1766 Jul 12 04:23 rootca-seung.key
-rw-------. 1 root root 1766 Jul 12 04:36 seung-gitlab.key
-rw-------. 1 root root 1766 Jul 12 04:37 seung-gitlab.key.enc
# vi seung-gitlab.conf
# cat seung-gitlab.conf
[ req ]
default_bits       = 2048
default_md         = sha1
default_keyfile    = rootca-seung.key
distinguished_name = req_distinguished_name
extensions         = v3_user

[ v3_user ]
basicConstraints       = CA:FALSE
authorityKeyIdentifier = keyid,issuer
subjectKeyIdentifier   = hash
keyUsage               = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage       = serverAuth,clientAuth
subjectAltName         = @alt_names

[ alt_names]
DNS.1 = 192.168.94.101
DNS.2 = 192.168.94.101
DNS.3 = 192.168.94.101

[req_distinguished_name ]
countryName                    = Country Name (2 letter code)
countryName_default            = KR
countryName_min                = 2
countryName_max                = 2

organizationName               = Organization name
organizationName_default       = seung

organizationalUnitName         = Organizational unit name
organizationalUnitName_default = dev lab

commonName                     = Common name
commonName_default             = cert for gitlab
commonName_max                 = 64

# openssl req -new -key seung-gitlab.key -out seung-gitlab.csr -config seung-gitlab.conf
Enter pass phrase for seung-gitlab.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [KR]:
Organization name [seung]:
Organizational unit name [dev lab]:
Common name [cert for gitlab]:
# openssl x509 -req -days 1825 -extensions v3_user -in seung-gitlab.csr -CA rootca-seung.crt -CAcreateserial -CAkey rootca-seung.key -out seung-gitlab.crt -extfile seung-gitlab.conf
Signature ok
subject=C = KR, O = seung, OU = dev lab, CN = cert for gitlab
Getting CA Private Key
Enter pass phrase for rootca-seung.key:
# openssl x509 -text -in seung-gitlab.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            0b:2b:fa:32:0e:1e:60:2a:1c:fa:5e:44:2e:d5:a2:5b:2a:c6:66:b2
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = KR, O = seung, OU = dev lab, CN = seung Self Signed CA
        Validity
            Not Before: Jul 12 11:48:36 2020 GMT
            Not After : Jul 11 11:48:36 2025 GMT
        Subject: C = KR, O = seung, OU = dev lab, CN = cert for gitlab
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:d9:9c:eb:76:bd:2c:1f:8c:e6:9f:c4:96:62:06:
                    fa:00:98:5a:c5:32:06:04:3c:72:80:08:a4:6d:0d:
                    f1:71:8c:f4:80:f0:97:34:f9:ad:ad:44:1d:6d:21:
                    7f:99:4b:8c:f0:73:9a:e3:ac:6d:a4:03:d7:eb:ac:
                    f2:ec:26:16:c0:fa:9d:66:41:d9:56:74:9a:fb:91:
                    16:e2:c5:0e:ad:07:f7:2f:69:31:fb:5c:83:b5:91:
                    97:90:e2:bc:ea:c4:b6:de:57:ce:9b:2a:1b:49:3c:
                    f3:16:96:ae:0a:a8:eb:27:44:29:82:42:d1:83:08:
                    de:3b:15:70:71:a1:4f:43:88:f7:ba:17:12:45:73:
                    a2:bb:a1:bb:99:71:71:56:a3:79:84:fd:a4:b6:43:
                    51:b1:4f:ed:7b:0c:cf:fe:1e:2f:90:c5:04:d6:50:
                    fc:2e:21:90:59:25:da:ed:38:82:0c:52:80:d1:a8:
                    5d:c5:40:b6:69:3b:87:e7:a6:be:91:89:1a:88:d9:
                    ef:94:b1:64:19:aa:72:63:0e:9f:bf:0e:39:07:fc:
                    54:60:67:c7:42:1d:28:a6:c8:87:39:bd:93:59:de:
                    bb:f3:f4:1c:40:98:ce:2a:fd:3d:6b:e0:92:98:aa:
                    66:c9:2b:8b:63:3c:d4:ae:eb:13:33:d6:30:c0:f4:
                    cf:c1
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            X509v3 Authority Key Identifier: 
                keyid:F4:41:99:19:5D:B5:59:D6:4F:C3:40:72:4E:1B:94:33:55:50:A8:7D

            X509v3 Subject Key Identifier: 
                D6:84:23:1F:46:98:73:80:2D:0F:73:E9:BF:A1:47:0A:7E:D5:AA:0E
            X509v3 Key Usage: 
                Digital Signature, Non Repudiation, Key Encipherment
            X509v3 Extended Key Usage: 
                TLS Web Server Authentication, TLS Web Client Authentication
            X509v3 Subject Alternative Name: 
                DNS:192.168.94.101, DNS:192.168.94.101, DNS:192.168.94.101
    Signature Algorithm: sha256WithRSAEncryption
         0b:ce:6c:55:35:b7:e8:39:32:d7:c9:3e:cd:75:42:41:f4:73:
         00:63:7c:09:03:b4:87:f5:6c:e1:d8:3d:70:5b:73:a7:3e:d6:
         30:53:19:66:fe:46:9b:9c:51:8b:fd:c5:9c:73:d7:e2:e4:ee:
         eb:91:cc:b2:9b:68:55:23:c6:24:88:83:e3:ec:84:03:f5:d4:
         c6:71:d9:3c:88:6f:ac:0f:2a:1c:65:62:27:bf:cf:15:4a:68:
         90:e8:87:33:b1:52:cd:9a:ed:9f:99:44:9a:13:5e:48:b0:c7:
         44:dd:d3:c5:2c:9c:21:f6:f2:b6:8d:28:65:b6:1c:6a:29:07:
         1d:b0:64:25:a4:b3:39:57:d5:47:64:68:30:ae:c7:d0:dc:24:
         33:f5:a5:61:1e:e1:c3:25:75:51:d5:51:90:64:bb:cd:ab:de:
         fe:b6:fd:e2:a6:b4:cb:78:f3:c7:07:f2:72:82:74:f9:02:81:
         35:b5:c3:8d:1f:5d:2c:d0:6c:d5:ee:84:7a:1e:90:03:94:d7:
         6f:ea:10:dd:98:13:b8:7f:ce:11:91:a1:9e:a1:5c:86:87:d2:
         fb:0a:24:02:85:4b:ea:c8:5a:fd:32:bb:65:18:8b:2d:9a:c1:
         b4:f4:59:b0:96:c2:9e:1d:08:71:36:42:b4:38:4d:f3:78:ba:
         9a:4a:9f:67
-----BEGIN CERTIFICATE-----
MIID2zCCAsOgAwIBAgIUCyv6Mg4eYCoc+l5ELtWiWyrGZrIwDQYJKoZIhvcNAQEL
BQAwTjELMAkGA1UEBhMCS1IxDjAMBgNVBAoMBXNldW5nMRAwDgYDVQQLDAdkZXYg
bGFiMR0wGwYDVQQDDBRzZXVuZyBTZWxmIFNpZ25lZCBDQTAeFw0yMDA3MTIxMTQ4
MzZaFw0yNTA3MTExMTQ4MzZaMEkxCzAJBgNVBAYTAktSMQ4wDAYDVQQKDAVzZXVu
ZzEQMA4GA1UECwwHZGV2IGxhYjEYMBYGA1UEAwwPY2VydCBmb3IgZ2l0bGFiMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2Zzrdr0sH4zmn8SWYgb6AJha
xTIGBDxygAikbQ3xcYz0gPCXNPmtrUQdbSF/mUuM8HOa46xtpAPX66zy7CYWwPqd
ZkHZVnSa+5EW4sUOrQf3L2kx+1yDtZGXkOK86sS23lfOmyobSTzzFpauCqjrJ0Qp
gkLRgwjeOxVwcaFPQ4j3uhcSRXOiu6G7mXFxVqN5hP2ktkNRsU/tewzP/h4vkMUE
1lD8LiGQWSXa7TiCDFKA0ahdxUC2aTuH56a+kYkaiNnvlLFkGapyYw6fvw45B/xU
YGfHQh0opsiHOb2TWd678/QcQJjOKv09a+CSmKpmySuLYzzUrusTM9YwwPTPwQID
AQABo4G1MIGyMAkGA1UdEwQCMAAwHwYDVR0jBBgwFoAU9EGZGV21WdZPw0ByThuU
M1VQqH0wHQYDVR0OBBYEFNaEIx9GmHOALQ9z6b+hRwp+1aoOMAsGA1UdDwQEAwIF
4DAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwOQYDVR0RBDIwMIIOMTky
LjE2OC45NC4xMDGCDjE5Mi4xNjguOTQuMTAxgg4xOTIuMTY4Ljk0LjEwMTANBgkq
hkiG9w0BAQsFAAOCAQEAC85sVTW36Dky18k+zXVCQfRzAGN8CQO0h/Vs4dg9cFtz
pz7WMFMZZv5Gm5xRi/3FnHPX4uTu65HMsptoVSPGJIiD4+yEA/XUxnHZPIhvrA8q
HGViJ7/PFUpokOiHM7FSzZrtn5lEmhNeSLDHRN3TxSycIfbyto0oZbYcaikHHbBk
JaSzOVfVR2RoMK7H0NwkM/WlYR7hwyV1UdVRkGS7zave/rb94qa0y3jzxwfycoJ0
+QKBNbXDjR9dLNBs1e6Eeh6QA5TXb+oQ3ZgTuH/OEZGhnqFchofS+wokAoVL6sha
/TK7ZRiLLZrBtPRZsJbCnh0IcTZCtDhN83i6mkqfZw==
-----END CERTIFICATE-----
# chmod 600 seung-gitlab.key