module Rai
  class Download < Sinatra::Application
    require 'csv'
    register Sinatra::CrossOrigin

    options "*" do
      response.headers["Allow"] = "HEAD,GET,OPTIONS"
      response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
    end

    configure do
      enable :cross_origin

      set :allow_origin, :any
      set :allow_methods, [:post, :get]
    end

    before do
      content_type :json, charset: 'utf-8'
    end

    helpers do
      def build_csv(surveys)
        CSV.generate do |row|
          row << csv_header
          surveys.each do |survey|
            row << row_values(survey)
          end
        end
      end

      def csv_header
        Survey::CSV_SORTED_DATA_FIELDS.map(&:to_s)
      end

      def row_values(survey)
        survey.full_data.values_at(*csv_header)
      end
    end

    get '/2016' do
      cache_control :public, max_age: 3600
      content_type 'application/csv'
      attachment "datos_completos_2016.csv"
      surveys = Survey.eager(:settlement, :indicator).where(year: 2016, visible: true).all

      build_csv(surveys)
    end

    post '/2016' do
      if params[:settlements_ids] && settlements_ids = params[:settlements_ids].split(',')
        cache_control :public, max_age: 3600
        content_type 'application/csv'
        attachment "datos_vista_actual_2016.csv"
        surveys = Survey.join(:settlements, [[:id, :settlement_id], [:string_id, settlements_ids]]).eager(:indicator).where(year: 2016, visible: true).all

        build_csv(surveys) unless surveys.empty?
      else
        halt 404, { message: "No hay barrios en la vista actual" }.to_json
      end
    end
  end
end
