require "rvm/capistrano"
set :rvm_type, :system

require 'bundler/capistrano'

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :application, "codecampo.com"
set :repository,  "git://github.com/chloerei/code_campo.git"
set :scm, :git
set :branch, "master"

set :user, "webuser"
set :deploy_to, "/home/webuser/#{application}"
set :use_sudo, false

role :web, "codecampo.com"
role :app, "codecampo.com"
role :db,  "codecampo.com", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :copy_config do
    run "cp #{deploy_to}/shared/config/*.yml #{release_path}/config"
  end
end

after "deploy:update_code", "deploy:copy_config"
load 'deploy/assets'
