import datetime
from fabric.api import local

def deploy():
    local('git pull origin master')
    local('npm install')
    local('bower install')
    local('cake build')
    local('node_modules/connect-assets/bin/connect-assets -s assets -gz -o public/assets')
    local('docker-compose build')
    local('docker-compose up -d')

def backup(output_dir=""):
    ip = local("docker inspect --format '{{ .NetworkSettings.Networks.dentaljs_default.IPAddress }}' dentaljs_db_1",
               capture=True)
    if not output_dir:
        output_dir = datetime.date.today().strftime('backup/%Y%m%d')

    local("mkdir -p %s" % output_dir)
    local("mongodump -o %s -h %s" % (output_dir, ip))
