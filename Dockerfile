FROM centos

ENV NODE_ENV "production" 
ENV PORT 8080

# install nodejs
RUN curl --silent --location https://rpm.nodesource.com/setup_5.x | bash -
RUN yum install -y nodejs git

# set working dir
RUN mkdir /app
WORKDIR /app

# install servers's dependencies
ADD package.json .
RUN npm install

# install client's dependencies
ADD bower.json .
RUN node_modules/bower/bin/bower install --allow-root

# add application's source to container
ADD src ./src
ADD bin ./bin
ADD assets ./assets
ADD public ./public
ADD views ./views
ADD Cakefile .

# build app
RUN npm install -g coffee-script
RUN node_modules/coffee-script/bin/cake build

# expose port
EXPOSE 8080

# run server
CMD ["bin/www"]
