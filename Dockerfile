FROM mongo:3.2
MAINTAINER zcw
ENV TZ=Asia/Shanghai

# wkhtmltopdf PACKAGE NEED
ENV BUILD_PACKAGES build-essential wget
ENV MAIN_PACKAGES  fontconfig libjpeg62-turbo libssl-dev libxext6 libxrender-dev xfonts-base xfonts-75dpi

ADD run.sh /root/
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends wget tar; \
	rm -rf /var/lib/apt/lists/*; \
	wget https://static.axboy.cn/leanote/leanote-linux-amd64-v2.6.1.bin.tar.gz -O /root/leanote.tar.gz; \
	tar -xzf /root/leanote.tar.gz -C /root/ ;\
	rm -f /root/leanote.tar.gz ;\
	chmod a+x /root/run.sh ;\
	chmod a+x /root/leanote/bin/run.sh ;\
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime ;\
	echo $TZ > /etc/timezone

RUN apt-get update -qq \
  && apt-get install --no-install-recommends -yq $BUILD_PACKAGES $MAIN_PACKAGES \
  && wget --quiet https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.jessie_amd64.deb \
  && dpkg -i wkhtmltox_0.12.5-1.jessie_amd64.deb \
  && apt-get remove -y $BUILD_PACKAGES \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && truncate -s 0 /var/log/*log


#RUN dpkg -i https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb || true
	
EXPOSE 9000
# CMD ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && /bin/bash /root/run.sh
CMD /bin/bash /root/run.sh
