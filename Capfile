# Load DSL and set up stages
require "capistrano/setup"
require "capistrano/deploy"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/bundler'
require "capistrano/puma"
install_plugin Capistrano::Puma  # Default puma tasks
require "capistrano/inspeqtor"
