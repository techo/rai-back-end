set :stage, :production
set :branch, :master

server DEPLOY['server'], user: DEPLOY['user'], roles: %w{web app}

set :puma_env, :production
set :puma_config_file, "#{shared_path}/#{DEPLOY['puma_config']}"
set :puma_conf, "#{shared_path}/#{DEPLOY['puma_config']}"
