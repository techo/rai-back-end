require File.expand_path('../config/application', __FILE__)
require "rake/testtask"

task :console do
  require "pry"
  # require "./config/application"

  ARGV.clear
  Pry.start
end

Rake::TestTask.new do |t|
  t.test_files = FileList['tests/**/*_test.rb']
  t.warning = false
end

# For Sprockets and assets precompile task
namespace :assets do
  desc "Precompile assets"
  task :precompile do
    environment = Rai::Editor.sprockets
    manifest = ::Sprockets::Manifest.new(environment.index, Rai::Editor.assets_public_path)
    manifest.compile(%w(editor.js editor.css *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2, *.otf))
  end

  desc "Clean assets"
  task :clean do
    FileUtils.rm_rf(Rai::Editor.assets_public_path)
  end
end

# For running Sequel migrations
namespace :db do
  desc "Create Database (In order to run this task you need to comment the first line (1), that's the one requiring the application itself"
  task :create do
    require 'yaml'
    require 'bundler/setup'
    Bundler.require :default

    dbconfig = YAML.load_file(File.expand_path('../config/settings.yml', __FILE__))['postgresql']

    Sequel.connect(dbconfig.merge('database' => 'postgres')) do |db|
      db.execute "DROP DATABASE IF EXISTS \"#{dbconfig['database']}\""
      db.execute "CREATE DATABASE \"#{dbconfig['database']}\""
    end
  end

  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    Sequel.extension :migration
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(DB, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(DB, "db/migrations")
    end
  end
end

Dir[File.expand_path('../tasks/**/*.rb', __FILE__)].each do |f|
  require f
end
