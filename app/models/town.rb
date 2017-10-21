class Town < Sequel::Model
  include Slugged

  many_to_one :city
  one_through_one :province, join_table: :cities, left_key: :id, left_primary_key: :city_id, right_key: :province_id

  one_to_many :settlements

end