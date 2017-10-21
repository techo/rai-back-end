class City < Sequel::Model
  include Slugged

  many_to_one :province
  one_to_many :towns
  one_through_one :country, join_table: :provinces, left_key: :id, left_primary_key: :province_id, right_key: :country_id

end