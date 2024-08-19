FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y -q gcc g++ libxslt-dev wget perl make
RUN wget https://github.com/openssl/openssl/releases/download/openssl-3.3.1/openssl-3.3.1.tar.gz && tar -zxvf openssl-3.3.1.tar.gz &&\
    cd openssl-3.3.1 &&\
    ./Configure linux-x86_64 &&\
    make && make install
RUN wget https://www.zlib.net/zlib-1.3.1.tar.gz && tar -zxvf zlib-1.3.1.tar.gz &&\
    cd zlib-1.3.1 &&\
    ./configure &&\
    make && make install
RUN wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.44/pcre2-10.44.tar.gz && tar -zxvf pcre2-10.44.tar.gz &&\
    cd pcre2-10.44 &&\
    ./configure &&\
    make && make install
RUN wget https://github.com/arut/nginx-dav-ext-module/archive/refs/tags/v3.0.0.tar.gz -O nginx-dav-ext-module-3.0.0.tar.gz && tar -zxvf nginx-dav-ext-module-3.0.0.tar.gz
RUN wget https://nginx.org/download/nginx-1.26.1.tar.gz && tar -zxvf nginx-1.26.1.tar.gz &&\ 
    cd nginx-1.26.1 &&\
    ./configure\
    --prefix=/opt/nginx \
    --with-compat \
    --with-file-aio \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_gunzip_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_dav_module \
    --with-http_slice_module \
    --with-stream \
    --with-stream_realip_module \
    --with-threads \
    --with-http_v2_module \
    --with-pcre=../pcre2-10.44 \
    --with-zlib=../zlib-1.3.1 \
    --add-module=../nginx-dav-ext-module-3.0.0 \
    --user=www-data \
    --group=www-data &&\ 
    make && make install &&\
    ln -s /opt/nginx/sbin/nginx /usr/bin/nginx
RUN echo "/usr/local/lib64" >> /etc/ld.so.conf.d/libc.conf && ldconfig
CMD ["nginx", "-g", "daemon off;"]
