module Services
  class SurveySaver
    attr_reader :errors, :survey

    SETTLEMENT_SENSITIVE_COLUMNS = {
      name: 'nombre_barrio',
      other_names: 'otros_nombres_barrio',
      creation_year: 'anio_creo_barrio',
      town_id: ''
    }.freeze

    def self.create(params)
      saver = send(:new, Survey.new(settlement_id: params[:survey][:settlement_id], year: params[:survey][:year], full_data: {}), params)
      saver.send(:create)
    end

    def self.update(survey, params)
      if params[:settlement_string_id] && params[:settlement_string_id] == survey.string_id
        saver = send(:new, survey, params)
        saver.send(:update)
      end
    end

    def self.update_settlement_info(settlement, changed_columns)
      return if (sensitive_columns = (SETTLEMENT_SENSITIVE_COLUMNS.keys & changed_columns)).empty?

      settlement.surveys.each do |survey|
        sensitive_columns.each do |column_name|
          if column_name == :town_id
            survey.full_data['localidad'] = settlement.town.name
            survey.full_data['departamento'] = settlement.city.name
            survey.full_data['provincia'] = settlement.province.name
          else
            survey.full_data[SETTLEMENT_SENSITIVE_COLUMNS[column_name]] = settlement.send(column_name)
          end
        end

        survey.save if survey.valid?
      end
    end

    def valid?
      errors.empty?
    end

    private

    def initialize(survey, params)
      @survey = survey
      @params = params
      @errors = []
      @survey_params = params[:survey].symbolize_keys
      sanitize_polygon!
      @survey_data_params = @survey_params.delete(:data).merge({
        "cantidad_de_familias" => @survey_params[:families_count],
        "poligono" => @survey_params[:poligon],
        "tipo_de_barrio" => @survey_params[:settlement_type],
      })
      @indicator_params = @survey_params.delete(:indicator)
      @indicator = load_or_initialize_indicator
      self
    end

    def sanitize_polygon!
      return if @survey_params[:poligon].empty?
    begin
      polygon = PolygonParser.new(@survey_params[:poligon])
      @survey_params[:poligon] = polygon.wkt!
    rescue Services::PolygonParser::Error => e
      @errors << e
    end
    end

    def load_or_initialize_indicator
      if @indicator_params[:id].nil? || @indicator_params[:id].to_s.empty?
        Indicator.new(survey_id: @survey.id, full_data: {})
      else
        Indicator.first(id: @indicator_params[:id], survey_id: @survey.id)
      end
    end

    def create
      return self unless valid?

      @survey.set_fields(@survey_params.merge(identify: @survey_data_params[:identificar]), [:families_count, :settlement_type, :poligon, :identify, :visible], missing: :skip)

      data_with_changes.each do |key, value|
        @survey.full_data[key.to_s] = value
      end
      set_settlement_values_on_full_data

      indicator_data_with_changes.each do |key, value|
        @indicator.full_data[key.to_s] = value.to_f
      end

      if @survey.valid?
        @survey.save
        @indicator.survey = @survey
        @indicator.save

        @survey.reload
      end
      self
    end

    def update
      return self unless valid?

      DB.transaction do
        @survey.lock!
        @survey.set_fields(@survey_params.merge(identify: @survey_data_params[:identificar]), [:families_count, :settlement_type, :poligon, :identify, :visible], missing: :skip)

        data_with_changes.each do |key, value|
          @survey.full_data[key.to_s] = value
        end

        indicator_data_with_changes.each do |key, value|
          @indicator.full_data[key.to_s] = value.to_f
        end

        if @survey.modified? || !data_with_changes.empty?
          @survey.save
        end

        if @indicator.modified? ||!indicator_data_with_changes.empty?
          @indicator.save
        end
      end
      self
    end

    def set_settlement_values_on_full_data
      @survey.full_data['id'] = @survey.string_id
      @survey.full_data['nombre_barrio'] = @survey.settlement_name
      @survey.full_data['otros_nombres_barrio'] = @survey.settlement_other_names
      @survey.full_data['anio_creo_barrio'] = @survey.settlement_creation_year
      @survey.full_data['localidad'] = @survey.town_name
      @survey.full_data['departamento'] = @survey.city_name
      @survey.full_data['provincia'] = @survey.province_name
    end

    def data_with_changes
      @data_with_changes ||= @survey_data_params.select do |key, value|
        @survey.full_data[key.to_s] != value
      end
    end

    def indicator_data_with_changes
      return @indicator_data_with_changes unless @indicator_data_with_changes.nil?

      @indicator_data_with_changes ||= @indicator_params[:data].select do |key, value|
        @indicator.send(:"#{key}") != value.to_f
      end
    end

  end
end
