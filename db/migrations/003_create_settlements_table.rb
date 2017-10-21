Sequel.migration do
  change do

    # Barrio / Asentamiento
    create_table :settlements do
      primary_key :id
      foreign_key :town_id, :towns, on_delete: :set_null
      String :string_id, size: 20, null: false, unique: true
      String :name, size: 255, null: false
      String :slug, size: 255, null: false
      String :other_names, size: 255
      Integer :creation_year
      String :poligon, text: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :string_id
      index :slug
      index [:town_id, :slug]
    end

    # Encuesta / Relevamiento
    create_table :surveys do
      primary_key :id
      foreign_key :settlement_id, :settlements, on_delete: :set_null
      Integer :year, null: false
      Boolean :editable, default: false, null: false
      String :settlement_type
      Integer :families_count
      String :identify
      String :poligon, text: true
      Jsonb :full_data, null: false, default: '{}'
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :year
      index :full_data, type: :gin
      index [:settlement_id, :year], unique: true
    end

  end
end