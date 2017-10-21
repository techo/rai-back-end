class Province < Sequel::Model
  include Slugged

  many_to_one :country
  one_to_many :cities
  many_to_many :towns, join_table: :cities, right_key: :id, right_primary_key: :city_id
end