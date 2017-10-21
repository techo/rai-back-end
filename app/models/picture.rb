class Picture < Sequel::Model
  many_to_one :settlement

  def string_id
    @string_id ||= settlement.string_id
  end

  def to_json
    url
  end
end