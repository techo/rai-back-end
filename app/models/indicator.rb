class Indicator < Sequel::Model
  many_to_one :survey
  one_through_one :settlement, join_table: :surveys, left_key: :id, left_primary_key: :survey_id, right_key: :settlement_id

  DATA_FIELDS = [:indice_vulnerabilidad_territorial, :servicios, :agua, :energia_electrica, :eliminacion_de_excretas, :emplazamientos, :inundacion, :servicios_de_emergencia, :policia, :bomberos, :ambulancia, :tenencia, :educacion, :jardin, :primaria, :secundaria, :alumbrado, :salud, :hospital, :salita, :basura, :asfalto, :transporte].freeze

  DATA_FIELDS.each do |field_key|
    define_method :"#{field_key}" do
      return if full_data.nil? || full_data.empty?
      full_data["#{field_key}"] && full_data["#{field_key}"].to_f
    end
  end

  def settlement_string_id
    @settlement_string_id ||= settlement.string_id
  end
end