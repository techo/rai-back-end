module LocationsHelper

  def country_options_for_select(selected_country)
    @country_options ||= Country.order(:name).all

    @country_options.map do |country|
      "<option value='#{country.id}' #{'selected' if country.id == selected_country}>#{country.name}</option>"
    end.join('')
  end

  def province_options_for_select(selected_province)
    @province_options ||= Province.order(:name).all

    @province_options.map do |province|
      "<option value='#{province.id}' #{'selected' if province.id == selected_province}>#{province.name}</option>"
    end.join('')
  end

  def city_options_for_select(selected_city)
    @city_options ||= City.eager(:province).order(:name).all

    @city_options.map do |city|
      "<option value='#{city.id}' #{'selected' if city.id == selected_city}>#{city.name} - #{city.province.name}</option>"
    end.join('')
  end

  def town_options_for_select(selected_town)
    @towns_options ||= Town.eager(city: :province).order(:name).all

    @towns_options.map do |town|
      "<option value='#{town.id}' #{'selected' if town.id == selected_town}>#{town.name} - #{town.city.name} - #{town.city.province.name}</option>"
    end.join('')
  end

  def create_location_title_text(location_type)
    case location_type
    when 'town' then return 'Crear nueva Localidad'
    when 'city' then return 'Crear nuevo Partido / Departamento'
    when 'province' then return 'Crear nueva Provincia'
    end
  end

  def create_location_button_text(location_type)
    case location_type
    when 'town' then return 'Crear localidad'
    when 'city' then return 'Crear partido / departamento'
    when 'province' then return 'Crear provincia'
    end
  end
end