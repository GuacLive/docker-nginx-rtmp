# docker-nginx-rtmp

## Running

Build container:
``docker build -t nginx-rtmp .``

Run container:
``docker run -p 1935:1935 -p 8081:8080 -e DOMAIN="127.0.0.1.xip.io" -v $(pwd)/hls:/tmp/hls nginx-rtmp``

