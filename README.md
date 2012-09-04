# CodeCampo

It's the source of http://codecampo.com , a light weight bbs for developer.

## Dependency

* ruby 1.9.3
* rails 3.2.3
* mongodb 1.8+
* nodejs (option for linux)

## Setup

    git clone git://github.com/chloerei/code_campo.git
    cd code_campo
    bundle install
    cp config/app_config.example.yml config/app_config.yml
    cp config/mongoid.example.yml config/mongoid.yml
    rake db:seed
    rails s

## Config admin

In config/app_config.yml, replace admin_emails, for example:

    admin_emails:
      - "youremail@yourdomain.com"
      - "anotheradmin@yourdomain.com"

Restart application, then the user use this email will be admin.

## More deploy step

Notice there is a whenever config, your can run `whenever --update-crontab` to update crontab config or use capistrano, see config/deploy.rb for more info.
