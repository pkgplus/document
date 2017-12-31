FROM centos
MAINTAINER Xue Bing <xuebing1110@gmail.com>

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN curl -L -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN yum -y install git
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN mkdir /app
WORKDIR /app
RUN mkdir -p content/post
COPY * /app/content/post/

# download hugo
RUN curl -LO http://download.bingbaba.com/hugo/hugo_0.25.1_Linux-64bit.tar.gz
RUN tar xzvf hugo_0.25.1_Linux-64bit.tar.gz
RUN mv hugo /usr/local/bin/hugo

# new site
RUN mkdir site
RUN hugo new site ./site

# themes
WORKDIR /app/site/themes
RUN git clone https://github.com/digitalcraftsman/hugo-icarus-theme.git

# markdown
WORKDIR /app/site
CMD ["hugo", "server", "--buildDrafts", "--appendPort=false", "--bind=0.0.0.0", "--theme=hugo-icarus-theme", "--contentDir=/app/content"]
