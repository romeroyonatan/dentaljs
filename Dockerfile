FROM centos

ENV NODE_ENV "production" 

RUN yum install -y epel-release
RUN yum install -y nodejs npm

MKDIR /app
MKDIR /data
COPY . /app

RUN cd /app; npm install --production
RUN cake build

CMD ['node', 'bin/www']
