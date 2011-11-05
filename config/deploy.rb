$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_bin_path, "/usr/local/bin"

require 'bundler/capistrano'

set :application, "codecampo.com"
set :repository,  "git://github.com/chloerei/code_campo.git"
set :scm, :git
set :branch, "master"

set :user, "webuser"
set :deploy_to, "~/#{application}"
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

  task :pipeline_precompile do
    run "cd #{current_path}; bundle exec rake assets:precompile"
  end

  task :copy_config do
    run "cp #{deploy_to}/shared/config/*.yml #{current_path}/config"
  end
end

after "deploy:symlink", "deploy:copy_config", "deploy:pipeline_precompile"
