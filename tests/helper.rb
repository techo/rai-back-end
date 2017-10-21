ENV['RACK_ENV'] = 'test'
require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'rack/test'
require 'purdytest'

require_relative '../config/application.rb'

SimpleCov.start do
  add_filter ".gs/"
end
