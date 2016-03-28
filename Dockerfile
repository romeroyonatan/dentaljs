FROM mhart/alpine-node:5

ENV NODE_ENV "production" 
ENV PORT 8080

# set working dir
WORKDIR /src

ADD package.json .
RUN npm install

# add application's source to container
ADD .app ./.app
ADD bin ./bin
ADD assets ./assets
ADD public ./public
ADD views ./views
ADD bower_components ./bower_components
ADD Cakefile .

# expose port
EXPOSE 8080

# run server
CMD ["node", "bin/www"]
