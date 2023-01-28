# DevOps Live #2 - Docker & Traefik Proxy

```
git clone git@github.com:ondrejsika/ondrejsika-docker-traefik.git
cd ondrejsika-docker-traefik
```

```
make set-http
docker-compose up -d
```

```
cd demo-sites/hello-world
export HOST=hello-http.droplet0.sikademo.com
make set-http
docker-compose up -d
```

```
cd ../nginx
export HOST=nginx-http.droplet0.sikademo.com
make set-http
docker-compose up -d
```

```
docker rm -f $(docker ps -aq)
cd ../..
make set-https-web
docker-compose up -d
```

```
cd demo-sites/hello-world
export HOST=hello.droplet0.sikademo.com
make set-https
docker-compose up -d
```

```
cd ../nginx
export HOST=nginx.droplet0.sikademo.com
make set-https
docker-compose up -d
```

Local

```
make set-https-cloudflare
docker-compose up -d
```

```
cd demo-sites/hello-world
export HOST=hello.local.sikademo.com
make set-https
docker-compose up -d
```

```
cd ../nginx
export HOST=nginx.local.sikademo.com
make set-https
docker-compose up -d
```
