module SurveyHelper

  SELECT_OPTIONS = {
    actividad_agropecuaria: ["", "a menos de 10 mts", "a menos de 100 mts", "a menos de 50 mts", "dentro del barrio", "no se encuentra cerca del barrio"],
    agua: ["", "agua corriente de red pública (cada vecino con su factura, con su propio medidor de agua en el frente de cada vivienda)", "camión cisterna (no hay conexión de ningún tipo, un camión abastece de agua)", "conexión irregular a la red pública (hecha por los vecinos, sin pagar factura / chapita de agua, generalmente mediante mangueras)", "otro", "perforación / pozo (cada familia tiene su propio pozo)", "tanque comunitario (tanque de agua la que estan conectados los vecinos)"],
    alcantarillado: ["", "no", "si, hechos por los vecinos.", "si, provistos por el estado."],
    alumbrado: ["", "no", "si, hechos por los vecinos.", "si, provistos por el estado."],
    asfalto: ["", "no", "si", "sí"],
    basural: ["", "a menos de 10 mts", "a menos de 100 mts", "a menos de 50 mts", "dentro del barrio", "no se encuentra cerca del barrio"],
    camino_de_alto_trafico: ["", "a menos de 10 mts", "a menos de 100 mts", "a menos de 50 mts", "dentro del barrio", "no se encuentra cerca del barrio"],
    centro_de_deportes: ["", "a menos de 10 cuadras (1 km)", "dentro del barrio", "entre 11 y 30 cuadras(1 y 3 km)", "entre 31 y 50 cuadras(3 y 5 km)", "más de 50 cuadras(+5 km)"],
    comisaria: ["", "a menos de 10 cuadras (1 km)", "dentro del barrio", "entre 11 y 30 cuadras(1 y 3 km)", "entre 31 y 50 cuadras(3 y 5 km)", "más de 50 cuadras(+5 km)"],
    cosas_que_mas_le_gustan1: ["", "el progreso percibido en el barrio", "ningun/o/a", "otro", "seguridad", "tranquilidad", "unión y familiaridad entre vecinos", "óptima localización"],
    desechos_industriales: ["", "a menos de 10 mts", "a menos de 100 mts", "a menos de 50 mts", "dentro del barrio", "no se encuentra cerca del barrio"],
    emergencias_ambulancia: ["", "a veces", "nunca", "siempre"],
    emergencias_bomberos: ["", "a veces", "nunca", "siempre"],
    emergencias_policia: ["", "a veces", "nunca", "siempre"],
    energia_calefaccion: ["", "energía eléctrica ( calentador/estufa eléctrico)", "gas en garrafa", "gas natural de red pública", "leña o carbón", "no tiene", "otro"],
    energia_cocinar: ["", "energía eléctrica ( calentador/horno eléctrico)", "gas en garrafa", "gas natural de red pública", "leña o carbón", "otro"],
    escuela_primaria: ["", "a menos de 10 cuadras (1 km)", "dentro del barrio", "entre 11 y 30 cuadras(1 y 3 km)", "entre 31 y 50 cuadras(3 y 5 km)", "más de 50 cuadras(+5 km)"],
    escuela_secundaria: ["", "a menos de 10 cuadras (1 km)", "dentro del barrio", "entre 11 y 30 cuadras(1 y 3 km)", "entre 31 y 50 cuadras(3 y 5 km)", "más de 50 cuadras(+5 km)"],
    excretas: ["", "desagüe a cámara séptica y pozo ciego", "desagüe sólo a pozo negro / ciego u hoyo, excavación a tierra", "otro", "red cloacal pública (conexión formal a cada domicilio, exclusivo para la eliminación de excretas)", "red cloacal pública conectada al pluvial, al desagüe de lluvia (conexión formal pero conectada con el alcantarillado o desagüe pluvial)."],
    hospital: ["", "a menos de 10 cuadras (1 km)", "dentro del barrio", "entre 11 y 30 cuadras(1 y 3 km)", "entre 31 y 50 cuadras(3 y 5 km)", "más de 50 cuadras(+5 km)"],
    identificar: ["", "cumple con la definición", "no cumple con la definición"],
    identificar_2: ["", "ASENTAMIENTO INFORMAL NUEVO", "TERRITORIO AMPLIADO"],
    inundaciones: ["", "cada vez que llueve fuerte (muchas veces por año)", "ocasionalmente (algunas veces por año)", "otro", "solamente cuando diluvia (una o dos veces por año)"],
    jardin_de_infantes: ["", "a menos de 10 cuadras (1 km)", "dentro del barrio", "entre 11 y 30 cuadras(1 y 3 km)", "entre 31 y 50 cuadras(3 y 5 km)", "más de 50 cuadras(+5 km)"],
    linea_de_tren: ["", "a menos de 10 mts", "a menos de 100 mts", "a menos de 50 mts", "dentro del barrio", "no se encuentra cerca del barrio"],
    luz: ["", "conexión irregular a la red pública. (enganchados a la red, cables a los postes de luz de la calle, de una familia a otra, etc)", "no tiene", "otro", "red pública con medidor comunitario / social. (no hay facturas individuales, no hay un medidor por familia, sino uno o varios medidores para muchas familias).", "red pública con medidores domiciliarios. (cada familia con su factura, con su propio medidor)"],
    mayores_problemas_barrio1: ["", "droga/alcohol/tabaco", "falta de acceso a los servicios", "falta de alumbrado", "falta de pavimentación", "inseguridad/delincuencia", "ningun/o/a", "otro"],
    organizaciones_externas: ["", "no", "sí"],
    parada_transporte_publico: ["", "a menos de 10 cuadras (1 km)", "dentro del barrio", "entre 11 y 30 cuadras(1 y 3 km)", "entre 31 y 50 cuadras(3 y 5 km)", "más de 50 cuadras(+5 km)"],
    pendiente: ["", "a menos de 10 mts", "a menos de 100 mts", "a menos de 50 mts", "dentro del barrio", "no se encuentra cerca del barrio"],
    plantacion_forestal: ["", "a menos de 10 mts", "a menos de 100 mts", "a menos de 50 mts", "dentro del barrio", "no se encuentra cerca del barrio"],
    plaza: ["", "a menos de 10 cuadras (1 km)", "dentro del barrio", "entre 11 y 30 cuadras(1 y 3 km)", "entre 31 y 50 cuadras(3 y 5 km)", "más de 50 cuadras(+5 km)"],
    por_que_parte_del_asentamiento_quedo_fuera_del_relevamiento_respuesta_multiple_: ["", "el barrio tiene 2 o 3 servicios y fue registrado en el 2013", "pasaron a ser menos de 8 familias", "todas las familias fueron desalojadas", "todas las familias fueron relocalizadas"],
    recoleccion_de_residuos: ["", "no", "si, de manera formal. (el camión ingresa al barrio)"],
    relleno_sanitario: ["", "a menos de 10 mts", "a menos de 100 mts", "a menos de 50 mts", "dentro del barrio", "no se encuentra cerca del barrio"],
    ribera_rio: ["", "a menos de 10 mts", "a menos de 100 mts", "a menos de 50 mts", "dentro del barrio", "no se encuentra cerca del barrio"],
    sala_medica: ["", "a menos de 10 cuadras (1 km)", "dentro del barrio", "entre 11 y 30 cuadras(1 y 3 km)", "entre 31 y 50 cuadras(3 y 5 km)", "más de 50 cuadras(+5 km)"],
    tipo_de_barrio: ["", "asentamiento", "barrio popular informal", "villa"],
    torres_de_alta_tension: ["", "a menos de 10 mts", "a menos de 100 mts", "a menos de 50 mts", "dentro del barrio", "no se encuentra cerca del barrio"],
  }.freeze

  SELECT_OPTIONS_KEYS = SELECT_OPTIONS.keys.freeze

  YEAR_OPTIONS = [ '2013', '2016' ]

  def is_a_select_input?(field_key)
    SELECT_OPTIONS_KEYS.include?(field_key.to_sym)
  end

  def options_for_select(field_key, selected_value)
    return [] unless is_a_select_input?(field_key)

    selected_value.strip! unless selected_value.nil?
    SELECT_OPTIONS[field_key.to_sym].map do |option_value|
      "<option value='#{option_value}' #{'selected' if option_value == selected_value}>#{option_value.capitalize}</option>"
    end.join('')
  end

  def options_for_years(selected_value = '2016')
    YEAR_OPTIONS.map do |option_value|
      "<option value='#{option_value}' #{'selected' if option_value == selected_value}>#{option_value}</option>"
    end.join('')
  end

  def settlement_options_for_select(selected_settlement_id)
    @settlement_options ||= Settlement.select(:id, :name, :string_id).order(:string_id).all

    @settlement_options.map do |settlement|
      "<option value='#{settlement.id}' #{'selected' if settlement.id == selected_settlement_id} >#{settlement.string_id} - #{settlement.name}</option>"
    end.join('')
  end

end