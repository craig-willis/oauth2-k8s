# oauth2_proxy  with Kubernetes NGINX ILB

This repo contains a simple example configuration to use oauth2_proxy to protect resources exposed via the Kubernetes NGINX ingress controller.

Prerequisites:
* DNS for domain
* Github Oauth client ID and secret (configured in oauth2_proxy.yaml)

To start:
```
./start.sh <domain>
```

To stop:
```
./stop.sh
```

## What it does

* Generates self-signed TLS certs and creates a secret
* Starts a simple nginx webserver (/)
* Starts a simple echoserver (/echo)
* Starts oauth2_proxy (/oauth2) with upstream also pointing to echoserver
* Creates ingress rules for each of the above
* Starts nginx ingress load balancer

## How to test:

* `http://<domain>/`: Displays default nginx webserver welcome page
* `http://<domain>/echo`: Calls the echo server directly
* `http://<domain>/oauth2/echo`: Calls the echo server via oauth2, redirects for Github authentication, prints request with oauth information 

### Echo server (no oauth proxy)
```
[Nov  9 17:19:17.961]
GET /echo HTTP/1.1
Host: www.domain.org
Connection: close
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8
Accept-Encoding: gzip, deflate, br
Accept-Language: en-US,en;q=0.8
Connection: close
Content-Length: 0
Cookie: _oauth2_proxy=...
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36
X-Forwarded-For: <ip address>
X-Forwarded-Host: www.domain.org
X-Forwarded-Port: 443
X-Forwarded-Proto: https
X-Real-Ip: <ip address>
```


```
[Nov  9 17:20:53.717]
Host: www.domain.org
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8
Accept-Encoding: gzip, deflate, br
Accept-Language: en-US,en;q=0.8
Authorization: Basic d2lsbGlzODo=
Cookie: _oauth2_proxy=...
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36
X-Forwarded-Access-Token: <oauth token>
X-Forwarded-Email: <email>
X-Forwarded-For: <ip address>
X-Forwarded-Host: www.domain.org
X-Forwarded-Port: 443
X-Forwarded-Proto: https
X-Forwarded-User: <username>
X-Real-Ip: <ip address>
```
