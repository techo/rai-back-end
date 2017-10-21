class Country < Sequel::Model
  include Slugged

  one_to_many :provinces
  many_to_many :cities, join_table: :provinces, right_key: :id, right_primary_key: :province_id
end