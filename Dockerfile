FROM mhart/alpine-node:base

ENV NODE_ENV "production" 
ENV PORT 8080

# set working dir
WORKDIR /src

# add application's source to container
ADD package.json .
ADD bin ./bin
ADD bower_components ./bower_components
ADD node_modules ./node_modules
ADD public ./public
ADD views ./views
ADD assets ./assets
ADD .app ./.app

# expose port
EXPOSE $PORT

# run server
CMD ["bin/www"]
