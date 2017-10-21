class Survey < Sequel::Model
  many_to_one :settlement
  one_to_one :indicator

  DATA_FIELDS = [:luz, :agua, :anio, :plaza, :asfalto, :basural, :excretas, :hospital, :poligono, :alumbrado, :comisaria, :localidad, :pendiente, :provincia, :ribera_rio, :identificar, :sala_medica, :departamento, :inundaciones, :identificar_2, :linea_de_tren, :nombre_barrio, :alcantarillado, :tipo_de_barrio, :energia_cocinar, :anio_creo_barrio, :escuela_primaria, :relleno_sanitario, :centro_de_deportes, :escuela_secundaria, :jardin_de_infantes, :emergencias_policia, :energia_calefaccion, :plantacion_forestal, :cantidad_de_familias, :emergencias_bomberos, :otros_nombres_barrio, :desechos_industriales, :actividad_agropecuaria, :camino_de_alto_trafico, :emergencias_ambulancia, :torres_de_alta_tension, :organizaciones_externas, :recoleccion_de_residuos, :cosas_que_mas_le_gustan1, :mayores_problemas_barrio1, :parada_transporte_publico, :por_que_parte_del_asentamiento_quedo_fuera_del_relevamiento_respuesta_multiple_].freeze

  EXTERNAL_FIELDS = [:anio, :localidad, :provincia, :departamento, :nombre_barrio, :poligono, :tipo_de_barrio, :anio_creo_barrio, :cantidad_de_familias, :otros_nombres_barrio].freeze

  CSV_SORTED_DATA_FIELDS = [:id, :provincia, :departamento, :localidad, :nombre_barrio, :otros_nombres_barrio, :tipo_de_barrio, :cantidad_de_familias, :anio_creo_barrio, :luz, :excretas, :agua, :energia_calefaccion, :energia_cocinar, :emergencias_policia, :emergencias_bomberos, :emergencias_ambulancia, :plantacion_forestal, :ribera_rio, :pendiente, :basural, :torres_de_alta_tension, :linea_de_tren, :camino_de_alto_trafico, :desechos_industriales, :actividad_agropecuaria, :relleno_sanitario, :inundaciones, :jardin_de_infantes, :escuela_primaria, :escuela_secundaria, :hospital, :sala_medica, :comisaria, :parada_transporte_publico, :plaza, :centro_de_deportes, :alcantarillado, :asfalto, :alumbrado, :recoleccion_de_residuos, :organizaciones_externas, :mayores_problemas_barrio1, :cosas_que_mas_le_gustan1, :poligono, :identificar, :anio].freeze

  def self.data_fields_keys
    (DATA_FIELDS - EXTERNAL_FIELDS).sort
  end

  data_fields_keys.each do |field_key|
    define_method :"#{field_key}" do
      return if full_data.nil? || full_data.empty?

      full_data["#{field_key}"]
    end
  end

  def visible?
    visible
  end

  def string_id
    @string_id ||= settlement.string_id
  end

  def polygon
    @polygon ||= poligon
  end

  def settlement_name
    @settlement_name ||= settlement.name
  end

  def settlement_other_names
    @settlement_other_names ||= settlement.other_names
  end

  def settlement_creation_year
    @settlement_creation_year ||= settlement.creation_year
  end

  def town_name
    @town_name ||= settlement.town.name
  end

  def city_name
    @city_name ||= settlement.city.name
  end

  def province_name
    @province_name ||= settlement.province.name
  end
end
