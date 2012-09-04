# CodeCampo

It's the source of http://codecampo.com , a light weight bbs for developer.

## Dependency

* ruby 1.9.3
* rails 3.2.3
* mongodb 1.8+

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

Then the user use this email will be admin.
