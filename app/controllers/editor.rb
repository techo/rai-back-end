require 'rack-flash'

module Rai
  class Editor < Sinatra::Application
    set :root, File.expand_path('../../../', __FILE__)
    set :views, File.join(root, 'app', 'views')

    set :public_folder, File.join(root, 'public')

    set :slim, layout: :'layouts/main'

    set :sprockets, Sprockets::Environment.new(root)
    set :assets_prefix, '/assets'
    set :digest_assets, true
    set :assets_public_path, File.join(public_folder, 'assets')

    set :raise_errors, false
    set :show_exceptions, false

    configure do
      register Sinatra::Partial
      set :partial_template_engine, :slim

      use Rack::Session::Redis, redis_server: "redis://#{LOCALENV['redis']['host']}:#{LOCALENV['redis']['port']}/0/rack:session"
      use Rack::Flash, sweep: true

      use Rack::Protection
      use Rack::Protection::AuthenticityToken
      use Rack::Protection::FormToken
      use Rack::Protection::RemoteReferrer

      # Setup Sprockets
      sprockets.append_path File.join(root, 'assets', 'fonts')
      sprockets.append_path File.join(root, 'assets', 'images')
      sprockets.append_path File.join(root, 'assets', 'javascripts')
      sprockets.append_path File.join(root, 'assets', 'stylesheets')
      sprockets.js_compressor  = :uglify
      sprockets.css_compressor = :scss
      # Configure Sprockets::Helpers (if necessary)
      Sprockets::Helpers.configure do |config|
        config.environment = sprockets
        config.prefix      = assets_prefix
        config.digest      = digest_assets
        config.public_path = public_folder

        # Force to debug mode in development mode
        # Debug mode automatically sets
        # expand = true, digest = false, manifest = false
        config.debug = true if development?
      end

      # Setup Warden
      set :auth_use_referrer, true
      set :auth_success_path, '/'
      set :auth_login_path, '/login'
      set :auth_login_template, :'auth/login'
      use Warden::Manager do |config|
        config.serialize_into_session{ |user| user.id } # serialize user to session
        config.serialize_from_session{ |id| User[id] } # serialize user from session
        # configuring strategies
        config.scope_defaults :default, strategies: [:password]
        config.failure_app = self
      end

      # Enable Logging
      logfile = File.new("#{root}/log/#{settings.environment}.log", 'a+')
      logfile.sync = true
      use Rack::CommonLogger, logfile
    end

    error_logfile = File.new("#{root}/log/#{settings.environment}_errors.log", 'a+')
    error_logfile.sync = true
    before do
      env["rack.errors"] = error_logfile
    end

    helpers do
      include Sprockets::Helpers
      include Warden::Helpers
      include LocationsHelper
      include SearchHelper
      include SurveyHelper

      def titleize(text)
        text.to_s.gsub(/_+/, ' ').gsub(/\b('?[a-z])/) { $1.capitalize }
      end

      def csrf_meta_tags
        %Q{<meta name="csrf-param" value="authenticity_token"/><meta name="csrf-token" value="#{session[:csrf]}"/>}
      end

      def authenticity_token
        %Q{<input type="hidden" name="authenticity_token" value="#{session[:csrf]}"/>}
      end

      def display_flash_message
        return unless flash.has?(:notice) || flash.has?(:error)

        if flash.has?(:notice)
          classname = "text-info"
          message = flash[:notice]
        else
          classname = "text-danger"
          message = flash[:error]
        end

        %Q{<div class="messages"><p class="#{classname}">#{message}</p></div>}
      end

      def menu_section_for(type)
        case type
        when 'settlements', 'surveys'
          type
        when 'towns', 'cities', 'provinces'
          'locations'
        end
      end

      def settlement_exist?(id)
        return false if id.empty?

        !Settlement.first(id: id.to_i).nil?
      end

      def string_id_valid?(string_id = nil)
        return false if string_id.empty?

        # First looks to match XXXX... (only numbers) and the second match looks for TE_XXXXXX or te_XXXXXX
        !!string_id.match(/^\d+$/) || !!string_id.match(/^[Tt][eE]_\d{6}$/)
      end
    end

    # GET assets
    get "/assets/*" do
      env["PATH_INFO"].sub!("/assets", "")
      settings.sprockets.call(env)
    end

    post '/unauthenticated/?' do
      status 401
      flash[:error] = 'El email y/o la contraseña no son válidas'
      warden.custom_failure! if warden.config.failure_app == self.class
      slim settings.auth_login_template, layout: nil
    end

    get '/login/?' do
      slim settings.auth_login_template, layout: nil
    end

    post '/login' do
      authenticate(params)
      redirect settings.auth_use_referrer && session[:return_to] ? session.delete(:return_to) : settings.auth_success_path
    end

    get '/logout/?' do
      authorize!
      logout
      redirect settings.auth_login_path
    end

    get '/' do
      authorize!
      redirect to('/settlements')
      # @menu_section = 'dashboard'
      # slim :index
    end

    get '/:type/search' do
      authorize!
      raise Sinatra::NotFound unless params[:q].to_s && params[:type].match(/(settlements|surveys|towns|cities|provinces)/)

      if params[:q].empty?
        redirect to("/#{params[:type]}")
      end

      @menu_section = menu_section_for(params[:type])
      @page = params.fetch("page", 1).to_i
      @results = Services::Finder.query(params[:type], params[:q]).order(:id).paginate(@page, 20)

      slim :'search/index'
    end

    get '/settlements/new' do
      authorize!
      @menu_section = 'settlements'
      @settlement = Settlement.new
      @surveys = @settlement.surveys
      slim :'settlements/new'
    end

    post '/settlements/new' do
      authorize!
      if params[:settlement] && string_id_valid?(params[:settlement][:string_id])
        settlement = Services::SettlementSaver.create(params)
        redirect to("/settlements/#{settlement.string_id}")
      else
        flash[:error] = 'Hubo un problema al intentar crear el Barrio / Asentamiento, ¿puede ser que el ID no tenga el formato correcto?'
        redirect to('/settlements/new')
      end
    end

    get '/settlements/:string_id' do
      authorize!
      @menu_section = 'settlements'
      @settlement = Settlement.eager(:surveys, :pictures).where(string_id: params[:string_id]).all.first
      @surveys = @settlement.surveys
      slim :'settlements/show'
    end

    get '/settlements/:string_id/survey/:year' do
      authorize!
      @menu_section = 'surveys'
      if @settlement = Settlement.first(string_id: params[:string_id])
        @survey = Survey.first(year: params[:year], settlement: @settlement)
        slim :'surveys/show'
      else
        redirect to('/settlements')
      end
    end

    put '/settlements/:string_id' do
      authorize!
      if params[:settlement] && settlement = Settlement.first(string_id: params[:string_id])
        Services::SettlementSaver.update(settlement, params)
        redirect to("/settlements/#{params[:string_id]}")
      else
        flash[:error] = 'Hubo un problema al intentar actualizar el Barrio / Asentamiento'
        redirect to('/settlements')
      end
    end

    get '/settlements/?' do
      authorize!
      @menu_section = 'settlements'
      @page = params.fetch("page", 1).to_i
      @settlements = Settlement.order(:id).paginate(@page, 20)
      slim :'settlements/index'
    end

    delete '/surveys/:settlement_id/:id' do
      authorize!
      if survey = Survey.first(id: params[:id], settlement_id: params[:settlement_id])
        survey.destroy
      end
      redirect back
    end

    get '/surveys/new' do
      authorize!
      @menu_section = 'surveys'
      if params[:settlement_id] && @settlement = Settlement.first(string_id: params[:settlement_id])
        @survey = Survey.new(settlement: @settlement)
      else
        @survey = Survey.new
      end
      slim :'surveys/new'
    end

    post '/surveys/new' do
      authorize!
      if params[:survey] && !params[:survey][:year].empty? && settlement_exist?(params[:survey][:settlement_id])
        saver = Services::SurveySaver.create(params)
        if saver.valid? && (survey = saver.survey)
          redirect to("/settlements/#{survey.string_id}/survey/#{survey.year}")
        else
          flash[:error] = saver.errors.map{ |e| e.message }.join("\n")
          slim :'surveys/new'
        end
      else
        flash[:error] = 'Hubo un problema al intentar crear la encuesta. Recordá que el año es obligatorio y no debe haber mas de una encuesta por año. Además debe pertenecer a un barrio o asentamiento válido'
        redirect to('/surveys/new')
      end
    end

    get '/surveys/?' do
      authorize!
      @menu_section = 'surveys'
      @page = params.fetch("page", 1).to_i
      @surveys = Survey.eager(:settlement).order(:id).paginate(@page, 20)
      slim :'surveys/index'
    end

    put '/surveys/:survey_id' do
      authorize!
      if params[:survey] && original_survey = Survey.first(id: params[:survey_id])
        saver = Services::SurveySaver.update(original_survey, params)
        if saver.valid? && (survey = saver.survey)
          redirect to("/settlements/#{survey.string_id}/survey/#{survey.year}")
        else
          flash[:error] = saver.errors.map{ |e| e.message }.join("\n")
          redirect to("/settlements/#{original_survey.string_id}/survey/#{original_survey.year}")
        end
      else
        flash[:error] = 'Hubo un problema al intentar actualizar la encuesta'
        redirect to('/surveys')
      end
    end

    delete '/locations/:type/:id' do
      authorize!
      raise Sinatra::NotFound unless params[:type].match(/(town|city|province)/)

      location_class = params[:type].capitalize.constantize
      if location = location_class.first(id: params[:id])
        location.destroy
      end
      redirect to('/locations')
    end

    get '/locations/:type/new' do
      authorize!
      raise Sinatra::NotFound unless params[:type].match(/(town|city|province)/)

      @menu_section = 'locations'

      @type = params[:type]
      location_class = @type.capitalize.constantize
      @location = location_class.new

      slim :'locations/new'
    end

    post '/locations/:type/new' do
      authorize!
      raise Sinatra::NotFound unless params[:type].match(/(town|city|province)/)

      if params.fetch(params[:type], nil)
        location_class = params[:type].capitalize.constantize
        location = Services::LocationSaver.create(location_class, params.fetch(params[:type]))
        redirect to("/locations/#{params[:type]}/#{location.id}/#{location.slug}")
      else
        flash[:error] = 'Hubo un problema al intentar crear esa ubicación'
        redirect to("/locations/#{type}/new")
      end
    end

    get '/locations/?' do
      authorize!
      @menu_section = 'locations'
      @towns = Town.eager(city: :province, province: :country).order(:name).all
      slim :'locations/index'
    end

    get '/locations/town/:town_id/?:town_slug?' do
      authorize!
      @menu_section = 'locations'
      @town = Town.eager(:settlements).where(id: params[:town_id]).all.first
      @settlements = @town.settlements
      slim :'locations/town'
    end

    get '/locations/city/:city_id/?:city_slug?' do
      authorize!
      @menu_section = 'locations'
      @city = City.eager(:towns, towns: :settlements).where(id: params[:city_id]).all.first
      @settlements = @city.towns.flat_map(&:settlements)
      slim :'locations/city'
    end

    get '/locations/province/:province_id/?:province_slug?' do
      authorize!
      @menu_section = 'locations'
      @province = Province.first(id: params[:province_id])
      slim :'locations/province'
    end

    put '/towns/:town_id' do
      authorize!
      if params[:town] && town = Town.first(id: params[:town_id])
        Services::LocationSaver.update(town, params[:town])
        redirect to("/locations/town/#{town.id}/#{town.slug}")
      else
        flash[:error] = 'Hubo un problema al intentar actualizar la localidad'
        redirect to('/locations')
      end
    end

    put '/cities/:city_id' do
      authorize!
      if params[:city] && city = City.first(id: params[:city_id])
        Services::LocationSaver.update(city, params[:city])
        redirect to("/locations/city/#{city.id}/#{city.slug}")
      else
        flash[:error] = 'Hubo un problema al intentar actualizar el partido / departamento'
        redirect to('/locations')
      end
    end

    put '/provinces/:province_id' do
      authorize!
      if params[:province] && province = Province.first(id: params[:province_id])
        Services::LocationSaver.update(province, params[:province])
        redirect to("/locations/province/#{province.id}/#{province.slug}")
      else
        flash[:error] = 'Hubo un problema al intentar actualizar la provincia'
        redirect to('/locations')
      end
    end
  end
end
