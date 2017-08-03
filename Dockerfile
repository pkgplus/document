FROM centos
MAINTAINER Xue Bing <xuebing1110@gmail.com>

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN curl -L -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN yum -y install git
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# test
RUN pwd
RUN ls -lrt

RUN mkdir /app
WORKDIR /app

RUN mkdir -p content/post
RUN cp -r * /app/content/post/

# download hugo
RUN curl -LO http://download.bingbaba.com/hugo/hugo_0.25.1_Linux-64bit.tar.gz
RUN tar xzvf hugo_0.25.1_Linux-64bit.tar.gz
RUN mv hugo /usr/local/bin/hugo

# new site
run hugo new site ./

# themes
RUN WORKDIR /app/themes
RUN git clone https://github.com/digitalcraftsman/hugo-icarus-theme.git

# markdown
RUN hugo server --buildDrafts --baseURL $BASE_URL --appendPort=false --bind=0.0.0.0 --theme=hugo-icarus-theme --contentDir=/app/content
