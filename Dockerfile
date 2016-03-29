FROM mhart/alpine-node:5

ENV NODE_ENV "production" 
ENV PORT 8080

# set working dir
WORKDIR /src

# add application's source to container
ADD .app ./.app
ADD bin ./bin
ADD assets ./assets
ADD public ./public
ADD views ./views
ADD bower_components ./bower_components
ADD node_modules ./node_modules
ADD Cakefile .
ADD package.json .

# expose port
EXPOSE 8080

# run server
CMD ["node", "bin/www"]
