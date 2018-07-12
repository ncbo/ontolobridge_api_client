# config valid for current version and patch releases of Capistrano
# lock "~> 3.11.0"

set :application, "ontolobridge_api_client"

set :repo_url, "https://github.com/ncbo/#{fetch(:application)}.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/srv/rails/#{fetch(:application)}"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml", "config/ontolobridge_config.rb"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :linked_dirs, %w{log tmp/pids tmp/cache public/system public/assets}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
# set :config_files, fetch(:linked_files)

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :passenger_restart_with_touch, true

namespace :deploy do

  desc 'Incorporate the bioportal_conf private repository content'
  #Get cofiguration from repo if PRIVATE_CONFIG_REPO env var is set 
  #or get config from local directory if LOCAL_CONFIG_PATH env var is set 
  task :get_config do
     #if ENV.include?('PRIVATE_CONFIG_REPO')
     if defined?(PRIVATE_CONFIG_REPO)
       TMP_CONFIG_PATH = "/tmp/#{SecureRandom.hex(15)}"
       on roles(:app, :web) do
          execute "git clone -q #{PRIVATE_CONFIG_REPO} #{TMP_CONFIG_PATH}"
          execute "rsync -av #{TMP_CONFIG_PATH}/#{fetch(:application)}/ #{release_path}/"
          execute "rm -rf #{TMP_CONFIG_PATH}"
       end
     elsif defined?(LOCAL_CONFIG_PATH)
       on roles(:app, :web) do
          execute "rsync -av #{LOCAL_CONFIG_PATH}/#{fetch(:application)}/ #{release_path}/"
       end
  #   else
  #     #copy local config files
  #     set :config_files, fetch(:linked_files) 
  #     before 'deploy:check:linked_files', 'config:push'
  #     end
     end
  end
#  before 'deploy:check:linked_files', 'config:push'
  after :updating, :get_config
end
