Sequel.migration do
  change do

    # Fotos
    create_table :pictures do
      primary_key :id
      foreign_key :settlement_id, :settlements, on_delete: :set_null
      String :url, size: 255, null: false, unique: true
      Integer :year
      DateTime :taken_at

      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :settlement_id
    end

    # Foto Satelital del Barrio / Asentamiento
    alter_table :settlements do
      add_column :satellite_pictures, :jsonb, null: false, default: '{}'
    end

    # Indicadores
    create_table :indicators do
      primary_key :id
      foreign_key :survey_id, :surveys, on_delete: :set_null
      Jsonb :full_data, null: false, default: '{}'
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :full_data, type: :gin
      index :survey_id
    end

  end
end