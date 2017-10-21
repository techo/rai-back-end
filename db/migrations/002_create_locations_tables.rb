Sequel.migration do
  change do
    # Paises
    create_table :countries do
      primary_key :id
      String :name, size: 255, null: false, unique: true
      String :slug, size: 255, null: false, unique: true
      String :identifier, size: 20, unique: true
      String :poligon
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :slug
    end

    # Provincias
    create_table :provinces do
      primary_key :id
      foreign_key :country_id, :countries, on_delete: :set_null
      String :name, size: 255, null: false
      String :slug, size: 255, null: false
      String :identifier, size: 20, unique: true
      String :poligon
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :slug
      index [:country_id, :slug], unique: true
    end

    # Partido / Departamento
    create_table :cities do
      primary_key :id
      foreign_key :province_id, :provinces, on_delete: :set_null
      String :name, size: 255, null: false
      String :slug, size: 255, null: false
      String :identifier, size: 20, unique: true
      String :poligon
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :slug
      index [:province_id, :slug], unique: true
    end

    # Localidad
    create_table :towns do
      primary_key :id
      foreign_key :city_id, :cities, on_delete: :set_null
      String :name, size: 255, null: false
      String :slug, size: 255, null: false
      String :identifier, size: 20, unique: true
      String :poligon
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :slug
      index [:city_id, :slug], unique: true
    end
  end
end