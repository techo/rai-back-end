class Settlement < Sequel::Model
  include Slugged

  many_to_one :town
  one_to_many :surveys
  one_to_many :pictures
  many_to_many :indicators, join_table: :surveys, right_key: :id, right_primary_key: :survey_id

  def city
    @city ||= town.city
  end

  def province
    @province ||= city.province
  end

  def satellite_pictures_url
    return {} if satellite_pictures.nil?

    satellite_pictures.each_with_object({}) do |(year, data), _hash|
      _hash[year] = data['url']
    end
  end
end