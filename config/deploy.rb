DEPLOY = YAML.load_file(File.expand_path('../deploy.yml', __FILE__))

# config valid only for current version of Capistrano
lock "3.8.0"

set :application, DEPLOY['application']
set :repo_url,    "git@github.com:techo/rai-back-end.git"
set :user,        DEPLOY['user']

set :pty,             true
set :use_sudo,        false
set :deploy_via,      :remote_cache
set :deploy_to,       "#{DEPLOY['path']}#{fetch(:application)}"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: DEPLOY['keys'] }

set :puma_threads,    [4, 8]
set :puma_workers,    1
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{shared_path}/log/puma.error.log"
set :puma_error_log,  "#{shared_path}/log/puma.access.log"
set :puma_preload_app, false
set :puma_worker_timeout, nil
set :puma_init_active_record, false

set :linked_files, DEPLOY['linked_files']
set :linked_dirs,  DEPLOY['linked_dirs']

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket and the config file'
  task :setup do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
      invoke 'puma:config'
    end
  end
end

namespace :assets do
  desc "precompile and sync assets to app servers"
  task :sync do
    on roles(:app), in: :parallel do |role|
      run_locally do
        execute "rsync -avr -e ssh ./public/assets/ #{role.user}@#{role.hostname}:#{shared_path}/public/assets/"
      end
    end
  end

  desc "Precompile assets locally"
  task :precompile do
    on primary(:app) do
      run_locally do
        rake 'assets:precompile'
      end
    end
  end
  desc "Cleanup assets locally"
  task :cleanup do
    run_locally do
      rake 'assets:clean'
    end
  end
  before "assets:sync", "assets:precompile"
  after "assets:sync", "assets:cleanup"
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  before :starting,          :check_revision
  # before :finishing,         'assets:sync'
  after  :finishing,         :cleanup
  after  :finishing,         :restart
end
