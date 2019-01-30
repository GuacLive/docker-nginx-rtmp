FROM alpine@sha256:68c39584cd9308df35b566b907d895c8b20d232b438d67b437cf5503ac3f23f6

LABEL maintainer="datagutt <datagutt@lekanger.no>"

ENV NGINX_VERSION=1.15.8
ENV NGINX_RTMP_VERSION=master

RUN apk  --no-cache add \
		git				\
		gcc				\
		binutils		\
		gmp				\
		isl				\
		libgomp			\
		libatomic		\
		libgcc			\
		openssl			\
		pkgconf			\
		pkgconfig		\
		mpfr3			\
		mpc1			\
		libstdc++		\
		ca-certificates	\
		libssh2			\
		expat			\
		pcre			\
		musl-dev		\
		libc-dev		\
		pcre-dev		\
		zlib-dev		\
		openssl-dev		\
		curl			\
		make

RUN	cd /tmp \
	&& curl --remote-name http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
	&& git clone https://github.com/GuacLive/BLSS.git -b ${NGINX_RTMP_VERSION} \
	&& tar xzf nginx-${NGINX_VERSION}.tar.gz \
	&& cd nginx-${NGINX_VERSION} \
	&& ./configure \
		--prefix=/opt/nginx \
		--with-http_ssl_module \
		--add-module=../BLSS \
	&& make CFLAGS="-Wimplicit-fallthrough=0" \
	&& make install

COPY nginx.conf /opt/nginx/conf/nginx.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN ln -sf /dev/stdout /opt/nginx/logs/access.log \
	&& ln -sf /dev/stderr /opt/nginx/logs/error.log

EXPOSE 1935 8080

CMD ["/usr/local/bin/entrypoint.sh"]
