Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      String :email, size: 255, null: false, unique: true
      String :password_digest, size: 255, null: false
      String :name, size: 255, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end