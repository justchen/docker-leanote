FROM ubuntu:16.04

MAINTAINER Justchen

ENV TZ=Asia/Shanghai \
    MONGO_VERSION=4.0.10

# wkhtmltopdf PACKAGE NEED
ENV BUILD_PACKAGES build-essential wget
ENV MAIN_PACKAGES  fontconfig libssl-dev libjpeg-turbo8 libxext6 libxrender-dev xfonts-base xfonts-75dpi tzdata net-tools wget tar


# WORKDIR /usr/local/bin/

ADD run.sh /root/



RUN set -ex; \
	apt-get update; \
  	apt-get install -yq $BUILD_PACKAGES $MAIN_PACKAGES; \
	wget https://static.axboy.cn/leanote/leanote-linux-amd64-v2.6.1.bin.tar.gz -O /root/leanote.tar.gz; \
	tar -xzf /root/leanote.tar.gz -C /root/ ;\
	rm -f /root/leanote.tar.gz ;\
	chmod a+x /root/run.sh ;\
	chmod a+x /root/leanote/bin/run.sh

RUN cd /usr/local/bin/ && \
    wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-${MONGO_VERSION}.tgz && \
    tar xf mongodb-linux-x86_64-${MONGO_VERSION}.tgz && \
    echo "export PATH=$PATH:/usr/local/bin/mongodb-linux-x86_64-${MONGO_VERSION}/bin" >> /etc/profile && \
    rm mongodb-linux-x86_64-${MONGO_VERSION}.tgz

# 设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata


RUN wget --quiet https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.xenial_amd64.deb \
  && dpkg -i wkhtmltox*.deb


#RUN dpkg -i https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb || true
	
EXPOSE 9000
CMD /bin/bash /root/run.sh
