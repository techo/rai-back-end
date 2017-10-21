module Services
  module Finder
    extend self

    MODELS_MAP = {
      settlements: Settlement
    }
    QUERY_FIELDS = {
      settlements: [:string_id, :name, :other_names]
    }.freeze

    def query(type, word)
      type = type.to_sym
      first_pass = true
      word_like = "%#{word}%"

      search = MODELS_MAP[type]
      QUERY_FIELDS[type].each do |field|
        sequel_like = Sequel.ilike(field, word_like)
        search = first_pass ? search.where(sequel_like) : search.or(sequel_like)
        first_pass = false
      end
      search
    end

  end
end