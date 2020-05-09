FROM jenkins/jnlp-slave
USER root
## install base
RUN echo \
    deb http://mirrors.aliyun.com/debian/ buster main non-free contrib\
    deb http://mirrors.aliyun.com/debian-security buster/updates main\
    deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib\
    deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib\
    > /etc/apt/sources.list
RUN apt update -y && apt install -y apt-transport-https  ca-certificates  curl  gnupg2  software-properties-common python-pip
## install docker
RUN curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/debian $(lsb_release -cs) stable"
RUN apt-get update && apt-get -y install docker-ce
VOLUME /root/.docker
COPY ./config.json /root/.docker/config.json
## install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt -y install yarn && apt-get clean && yarn config set registry 'https://registry.npm.taobao.org'
##install maven
ADD ./maven.tar.gz /usr/share/
RUN mkdir /usr/lib/jvm/ && ln -s /usr/local/openjdk-8 /usr/lib/jvm/java-1.8.0-openjdk
## install sonar scanner
ADD ./sonar-scanner.tar.gz /opt 
## install python jenkins modules
COPY ./pip.conf /root/.pip/pip.conf 	
RUN pip install python-jenkins
## install kubectl
#RUN cd /usr/bin && curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/linux/amd64/kubectl
#RUN chmod +x /usr/bin/kubectl
#COPY ./admin.conf /root/.kube/config
#RUN wget -O /root/helm.tar.gz https://get.helm.sh/helm-v2.15.2-linux-amd64.tar.gz
#RUN cd /root && tar -zxvf helm.tar.gz
#RUN cd /root && mv /root/linux-amd64/helm /usr/bin/helm
#RUN chmod +x /usr/bin/helm
#RUN cp -a /usr/bin/helm /usr/local/bin/helm
#RUN helm init --upgrade
USER root
