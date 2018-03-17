# docker-nginx-rtmp

## Running

Build container:
``docker build -t nginx-rtmp .``

Run container:
``docker run -p 1935:1935 -p 8080:8080 -v $(pwd)/hls:/tmp/hls nginx-rtmp``

