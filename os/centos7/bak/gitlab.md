# df -m
Filesystem     1M-blocks  Used Available Use% Mounted on
devtmpfs            1860     0      1860   0% /dev
tmpfs               1876     0      1876   0% /dev/shm
tmpfs               1876    10      1867   1% /run
tmpfs               1876     0      1876   0% /sys/fs/cgroup
/dev/sda3          18121  4640     13482  26% /
/dev/sda1            283   144       120  55% /boot
tmpfs                376     2       375   1% /run/user/42
tmpfs                376     6       370   2% /run/user/1000
# dnf install -y curl policycoreutils openssh-server
Last metadata expiration check: 0:27:35 ago on Sun 12 Jul 2020 03:02:43 AM PDT.
Package curl-7.61.1-12.el8.x86_64 is already installed.
Package policycoreutils-2.9-9.el8.x86_64 is already installed.
Package openssh-server-8.0p1-4.el8_1.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
# systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2020-07-12 03:09:34 PDT; 20min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 1113 (sshd)
    Tasks: 1 (limit: 23800)
   Memory: 5.1M
   CGroup: /system.slice/sshd.service
           └─1113 /usr/sbin/sshd -D -oCiphers=aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256->

...

# firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: ens33
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 
  protocols: 
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
  
# firewall-cmd --permanent --add-service=http
# firewall-cmd --permanent --add-port=22443/tcp
# systemctl reload firewalld
# firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: ens33
  sources: 
  services: cockpit dhcpv6-client http ssh
  ports: 22443/tcp
  protocols: 
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
	
# dnf install -y postfix
# systemctl enable postfix
# systemctl start postfix
# curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
# EXTERNAL_URL="http://192.168.94.101" dnf install -y gitlab-ee
# df -m
Filesystem     1M-blocks  Used Available Use% Mounted on
devtmpfs            1860     0      1860   0% /dev
tmpfs               1876     1      1876   1% /dev/shm
tmpfs               1876    12      1865   1% /run
tmpfs               1876     0      1876   0% /sys/fs/cgroup
/dev/sda3          18121  6851     11271  38% /
/dev/sda1            283   144       120  55% /boot
tmpfs                376     2       375   1% /run/user/42
tmpfs                376     6       370   2% /run/user/1000
# cd /etc/gitlab/
# pwd
/etc/gitlab
# ll
total 128
-rw-------. 1 root root 108217 Jul 12 03:49 gitlab.rb
-rw-------. 1 root root  18892 Jul 12 03:54 gitlab-secrets.json
drwxr-xr-x. 2 root root      6 Jul 12 03:50 trusted-certs
# vi gitlab.rb
# cat gitlab.rb
...
external_url 'https://192.168.94.101:22443'
...
nginx['redirect_http_to_https'] = true
...
# mkdir -p /etc/gitlab/ssl
# chmod 755 /etc/gitlab/ssl
# ll
total 128
-rw-------. 1 root root 108361 Jul 12 05:19 gitlab.rb
-rw-------. 1 root root  18892 Jul 12 03:54 gitlab-secrets.json
drwxr-xr-x. 2 root root      6 Jul 12 05:19 ssl
drwxr-xr-x. 2 root root      6 Jul 12 03:50 trusted-certs
# cp /root/pki/seung-gitlab.key /root/pki/seung-gitlab.crt /etc/gitlab/ssl/
# ll ssl
total 8
-rw-r--r--. 1 root root 1399 Jul 12 05:20 seung-gitlab.crt
-rw-------. 1 root root 1766 Jul 12 05:20 seung-gitlab.key
# gitlab-ctl reconfigure
# curl -k https://192.168.94.101:22443
<!DOCTYPE html>
<html>
<head>
  <meta content="width=device-width, initial-scale=1, maximum-scale=1" name="viewport">
  <title>GitLab is not responding (502)</title>
  <style>
    body {
      color: #666;
      text-align: center;
      font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
      margin: auto;
      font-size: 14px;
    }

    h1 {
      font-size: 56px;
      line-height: 100px;
      font-weight: 400;
      color: #456;
    }

    h2 {
      font-size: 24px;
      color: #666;
      line-height: 1.5em;
    }

    h3 {
      color: #456;
      font-size: 20px;
      font-weight: 400;
      line-height: 28px;
    }

    hr {
      max-width: 800px;
      margin: 18px auto;
      border: 0;
      border-top: 1px solid #EEE;
      border-bottom: 1px solid white;
    }

    img {
      max-width: 40vw;
      display: block;
      margin: 40px auto;
    }

    a {
      line-height: 100px;
      font-weight: 400;
      color: #4A8BEE;
      font-size: 18px;
      text-decoration: none;
    }

    .container {
      margin: auto 20px;
    }

    .go-back {
      display: none;
    }

  </style>
</head>

<body>
  <a href="/">
    <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjEwIiBoZWlnaHQ9IjIxMCIgdmlld0JveD0iMCAwIDIxMCAyMTAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgPHBhdGggZD0iTTEwNS4wNjE0IDIwMy42NTVsMzguNjQtMTE4LjkyMWgtNzcuMjhsMzguNjQgMTE4LjkyMXoiIGZpbGw9IiNlMjQzMjkiLz4KICA8cGF0aCBkPSJNMTA1LjA2MTQgMjAzLjY1NDhsLTM4LjY0LTExOC45MjFoLTU0LjE1M2w5Mi43OTMgMTE4LjkyMXoiIGZpbGw9IiNmYzZkMjYiLz4KICA8cGF0aCBkPSJNMTIuMjY4NSA4NC43MzQxbC0xMS43NDIgMzYuMTM5Yy0xLjA3MSAzLjI5Ni4xMDIgNi45MDcgMi45MDYgOC45NDRsMTAxLjYyOSA3My44MzgtOTIuNzkzLTExOC45MjF6IiBmaWxsPSIjZmNhMzI2Ii8+CiAgPHBhdGggZD0iTTEyLjI2ODUgODQuNzM0Mmg1NC4xNTNsLTIzLjI3My03MS42MjVjLTEuMTk3LTMuNjg2LTYuNDExLTMuNjg1LTcuNjA4IDBsLTIzLjI3MiA3MS42MjV6IiBmaWxsPSIjZTI0MzI5Ii8+CiAgPHBhdGggZD0iTTEwNS4wNjE0IDIwMy42NTQ4bDM4LjY0LTExOC45MjFoNTQuMTUzbC05Mi43OTMgMTE4LjkyMXoiIGZpbGw9IiNmYzZkMjYiLz4KICA8cGF0aCBkPSJNMTk3Ljg1NDQgODQuNzM0MWwxMS43NDIgMzYuMTM5YzEuMDcxIDMuMjk2LS4xMDIgNi45MDctMi45MDYgOC45NDRsLTEwMS42MjkgNzMuODM4IDkyLjc5My0xMTguOTIxeiIgZmlsbD0iI2ZjYTMyNiIvPgogIDxwYXRoIGQ9Ik0xOTcuODU0NCA4NC43MzQyaC01NC4xNTNsMjMuMjczLTcxLjYyNWMxLjE5Ny0zLjY4NiA2LjQxMS0zLjY4NSA3LjYwOCAwbDIzLjI3MiA3MS42MjV6IiBmaWxsPSIjZTI0MzI5Ii8+Cjwvc3ZnPgo="
       alt="GitLab Logo" />
  </a>
  <h1>
    502
  </h1>
  <div class="container">
    <h3>Whoops, GitLab is taking too much time to respond.</h3>
    <hr />
    <p>Try refreshing the page, or going back and attempting the action again.</p>
    <p>Please contact your GitLab administrator if this problem persists.</p>
    <a href="javascript:history.back()" class="js-go-back go-back">Go back</a>
  </div>
  <script>
    (function () {
      var goBack = document.querySelector('.js-go-back');

      if (history.length > 1) {
        goBack.style.display = 'inline';
      }
    })();
  </script>
</body>
</html>





