module Rai
  module Api
    class Base < Sinatra::Application
      register Sinatra::CrossOrigin

      options "*" do
        response.headers["Allow"] = "HEAD,GET,OPTIONS"
        response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
      end

      configure do
        enable :cross_origin

        set :allow_origin, :any
        set :allow_methods, [:get, :options]
      end

      before do
        content_type :json, charset: 'utf-8'
      end
    end
  end
end