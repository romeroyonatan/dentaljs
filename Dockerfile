FROM centos

ENV NODE_ENV "production" 

# install nodejs
RUN curl --silent --location https://rpm.nodesource.com/setup_5.x | bash -
RUN yum install -y nodejs

# set working dir
RUN mkdir /app
WORKDIR /app

# install app's dependencies
ADD package.json .
RUN npm install

# add application's source to container
ADD src ./src
ADD bin ./bin
ADD assets ./assets
ADD public ./public
ADD views ./views
ADD bower.json .
ADD .bowerrc .
ADD Cakefile .

# install client's dependency
#RUN bower install

# build app
RUN npm install -g coffee-script
RUN cake build

# expose port
EXPOSE 3000

# run server
CMD ["/app/bin/www"]
