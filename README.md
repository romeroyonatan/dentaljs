[![Build Status](https://travis-ci.org/romeroyonatan/dentaljs.svg?branch=master)](https://travis-ci.org/romeroyonatan/dentaljs)

# Dentaljs

> Dental management software

## Requirements

* [Nodejs 5 + npm](https://nodejs.org/en/download/package-manager/)
* gulp & bower
  ```/bin/bash
  sudo npm install -g gulp bower
  ```

* [Docker-engine](https://docs.docker.com/engine/installation/linux/fedora/)

* Docker-compose
  ```/bin/bash
  sudo pip install -U docker-compose
  ```

## Deploy

```/bin/bash
npm install --production
gulp deploy    
```

## Backup

```/bin/bash
gulp backup
```


Importing fixtures
-----------------------------------------------------------------------------
```sh
mongoimport fixtures/issues.json --jsonArray -d dentaljs
mongoimport fixtures/accountingcategories.json --jsonArray -d dentaljs
```
