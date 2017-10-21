module SearchHelper
  NAMES_MAP = {
    settlements: 'Asentamientos',
    surveys:     'Encuestas',
    towns:       'Localidades',
    cities:      'Partidos / Departamentos',
    provinces:   'Provincias'
  }.freeze

  SINGULARS_MAP = {
    settlements: :settlement,
    surveys:     :survey,
    towns:       :town,
    cities:      :city,
    provinces:   :province
  }.freeze

  def searching_for_name(type)
    NAMES_MAP[type.to_sym]
  end

  def searching_for_word(type)
    case type.to_sym
    when :settlements
      'encontrados'
    else
      'encontradas'
    end
  end

  def searching_for_singular_type(type)
    SINGULARS_MAP[type.to_sym]
  end
end