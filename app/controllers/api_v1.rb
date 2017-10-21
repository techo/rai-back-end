module Rai
  module Api
    class V1 < Base

      get '/ping' do
        { success: :pong }.to_json
      end

      get '/surveys/?:year?' do
        cache_control :public, max_age: 3600
        year = params.fetch("year", 2016).to_i
        if year == 2013
          send_file File.join('db', 'seeds', 'r2013.json')
        else
          surveys = Survey.eager(:settlement, :indicator).where(year: year, visible: true).all
          halt 404, { message: "No hay encuestas del año #{year}" }.to_json if surveys.empty?

          response = surveys.each_with_object({}) do |survey, _hash|
            _hash[survey.string_id] = survey.full_data.tap do |_data|
              _data[:indicadores] = if survey.indicator && !(indicator_data = survey.indicator.try(:full_data)).empty?
                indicator_data
              end
            end
          end
          response.to_json
        end
      end

      get '/missing' do
        related_provinces_ids = City.select(:province_id).all.uniq.map(&:province_id)
        missing_provinces = Province.where("id NOT IN ?", related_provinces_ids)

        response = missing_provinces.each_with_object({}) do |province, _hash|
          _hash["NO_RELEVADO_#{province.id}"] = {
            id: "NO_RELEVADO_#{province.id}",
            provincia: province.name,
            no_relevado: true,
            localidad: "",
            departamento: "",
            nombre_barrio: "",
            poligono: ""
          }
        end
        response.to_json
      end

      get '/pictures' do
        settlements = Settlement.eager(:pictures).all

        response = settlements.each_with_object({}) do |settlement, _hash|
          _hash[settlement.string_id] = {
            fotos: settlement.pictures.map(&:to_json)
          }
        end
        response.to_json
      end

      get '/satellite_pictures' do
        settlements_with_satellite_pictures = Settlement.select(:string_id, :satellite_pictures).where("satellite_pictures ? '2013'").or("satellite_pictures ? '2016'")

        response = settlements_with_satellite_pictures.each_with_object({}) do |settlement, _hash|
          _hash[settlement.string_id] = settlement.satellite_pictures_url
        end
        response.to_json
      end

    end
  end
end
