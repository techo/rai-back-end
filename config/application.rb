require 'yaml'
require 'rubygems'
require 'bundler/setup'

Bundler.require :default

LOCALENV = YAML.load_file(File.expand_path('../settings.yml', __FILE__))

require 'pry' if development?

# Add them by one because the issue with the sinatra/namespace lib
require 'sinatra/content_for'
require 'sinatra/cookies'
require 'sinatra/json'
require 'sinatra/reloader' if development?

# # Because to the issue overriding namespace method in rake
# # https://github.com/sinatra/sinatra-contrib/issues/111#issuecomment-243329788
# self.instance_eval do
#   alias :namespace_pre_sinatra :namespace if self.respond_to?(:namespace, true)
# end
# require 'sinatra/namespace'
# self.instance_eval do
#   alias :namespace :namespace_pre_sinatra if self.respond_to?(:namespace_pre_sinatra, true)
# end

require 'will_paginate/sequel'

$redis = Redis.new( host: LOCALENV['redis']['host'], port: LOCALENV['redis']['port'] )

config_hash = {
  adapter: LOCALENV['postgresql']['adapter'],
  user: LOCALENV['postgresql']['user'],
  password: LOCALENV['postgresql']['password'],
  host: LOCALENV['postgresql']['host'],
  database: LOCALENV['postgresql']['database']
}.tap do |_config|
  _config[:logger] = Logger.new('log/db.log') if development?
end

Sequel.default_timezone = :utc
DB = Sequel.connect(config_hash)
DB.extension :pg_array, :pg_json
DB.extension :pagination
Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :json_serializer

require File.dirname(__FILE__) + '/warden'

Dir[File.expand_path('../../support/**/*.rb', __FILE__)].each do |f|
  require f
end
Dir[File.expand_path('../../app/{models,services,helpers}/*.rb', __FILE__)].each do |f|
  require f
end
Dir[File.expand_path('../../app/controllers/{api_base,api_v1,download,editor}.rb', __FILE__)].each do |f|
  require f
end
