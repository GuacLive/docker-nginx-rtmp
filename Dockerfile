FROM alfg/ffmpeg:snapshot

LABEL maintainer="datagutt <datagutt@lekanger.no>"

ENV NGINX_VERSION=1.15.9
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
	&& make \
	&& make install

COPY nginx.conf /opt/nginx/conf/nginx.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN ln -sf /dev/stdout /opt/nginx/logs/access.log \
	&& ln -sf /dev/stderr /opt/nginx/logs/error.log

EXPOSE 1935 8080

CMD ["/usr/local/bin/entrypoint.sh"]
