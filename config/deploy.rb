require "bundler/capistrano"

set :application, "walkin_management"
set :repository, "git@github.com:eshamukherjee08/Esha_VIMapp.git"
set :deploy_to, "/var/www/#{application}"
set :scm, :git
set :keep_releases, 5
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "173.45.225.100"                          # Your HTTP server, Apache/etc
role :app, "173.45.225.100"                          # This may be the same as your `Web` server
role :db,  "173.45.225.100", :primary => true

set :user, 'deployer'
set :use_sudo, true
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
# 
# set :default_environment, {
#   'LANG' => 'en_US.UTF-8'
#  }

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# after "deploy", "deploy:bundle_gems"
# after "deploy:bundle_gems", "deploy:restart"
# after "deploy:update_code", "deploy:bundle_new_release"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  
  # task :bundle_gems do
  #   run "cd #{deploy_to}/current && /usr/local/bin/bundle install vendor/gems"
  # end
  
  
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :after_symlink, :roles => :app do
    run "cp #{shared_path}/database.yml #{current_path}/config/database.yml"
  end
  
  task :bundle_new_release do
    run "cd #{release_path} && LANG='en_US.UTF-8' && LC_ALL='en_US.UTF-8' #{ruby_bins}/bundle install --path vendor/bundle --without test"
  end

  desc "Deploy with migrations"
  task :long do
    transaction do
      # run "export LANG=en_US.UTF-8"
      update_code
      web.disable
      symlink
      migrate
    end

    restart
    web.enable
    cleanup
  end

  desc "Run cleanup after long_deploy"
  task :after_deploy do
    cleanup
  end

end

namespace :db do
  desc "Snapshots production db and dumps to development environment"
  task :backup, :roles => :db, :only => { :primary => true } do    
    prod_config = capture "cat #{shared_path}/database.yml"
    prod = YAML::load(prod_config)["production"]
    dev  = YAML::load_file("config/database.yml")["development"]
    dump = "/tmp/#{Time.now.to_i}-#{application}.sql"
    run %{mysqldump --user=#{prod["username"]} --password=#{prod["password"]} #{prod["database"]} > #{dump}}
    get dump, dump
    run "rm #{dump}"
    
    system %{mysqladmin --user=#{dev["username"]} --password=#{dev["password"]} drop #{dev["database"]}}
    system %{mysqladmin --user=#{dev["username"]} --password=#{dev["password"]} create #{dev["database"]}}
    system %{mysql --user=#{dev["username"]} --password=#{dev["password"]} #{dev["database"]} < #{dump}}
    system "rm #{dump}"
  end
end

