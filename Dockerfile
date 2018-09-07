# Dockerfile for nomad-axe
FROM debian:jessie
MAINTAINER axerunners
LABEL description="Dockerized AXE daemon for running masternodes"

RUN apt-get update \
 && apt-get install -y curl iptables git python-virtualenv \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

 ENV AXE_DOWNLOAD_URL  github.com/AXErunners/axe/releases/download/v1.1.5/axecore-1.1.5-x86_64-linux-gnu.tar.gz
 RUN cd /tmp \
  && curl -sSL "$AXE_DOWNLOAD_URL" -o axe.tgz "$AXE_DOWNLOAD_URL.asc" -o axe.tgz.asc \
  && tar xzf axe.tgz --no-anchored axed axe-cli --transform='s/.*\///' \
  && mv axed axe-cli /usr/bin/ \
  && rm -rf axe* \
  && echo "#""!/bin/bash\n/usr/bin/axed -datadir=/axe \"\$@\"" > /usr/local/bin/axed \
  && echo "#""!/bin/bash\n/usr/bin/axe-cli -datadir=/axe \"\$@\"" > /usr/local/bin/axe-cli \
  && chmod a+x /usr/local/bin/axed /usr/local/bin/axe-cli /usr/bin/axed /usr/bin/axe-cli


ENV HOME /axe
RUN /usr/sbin/useradd -s /bin/bash -m -d /axe axe \
 && chown axe:axe -R /axe
ADD axe.conf /axe/axe.conf
RUN chown axe:axe -R /axe
USER axe

RUN cd axe \
 && git clone git://github.com/axerunners/sentinel \
 && cd sentinel \
 && virtualenv venv \
 && venv/bin/pip install -r requirements.txt \
 && ln -s ~ ~/.axecore

#fetch to semi recent block
#warning! makes for large image, but fast startup times.
ENV BLOCKS 35369
RUN axed & sleep 10;echo "syncing blocks(this will take a while)"; while [ ${t:-0} -lt $BLOCKS ];do t=$(axe-cli getinfo|grep blocks); t=${t##* };t=${t%,};echo -n ${t:-0}" "; sleep 10;done;axe-cli getinfo;axe-cli stop;sleep 10

RUN rm /axe/wallet.dat

EXPOSE 9937

WORKDIR /axe
CMD echo externalip=${MNIP%:*} >> /axe/axe.conf; echo masternodeprivkey=$MNKEY >> /axe/axe.conf; while sleep 60;do sentinel/venv/bin/python sentinel/bin/sentinel.py;done& exec axed -printtoconsole
