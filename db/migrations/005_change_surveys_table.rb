Sequel.migration do
  change do

    # Cambiar la tabla de Encuentas para contemplar si es o no visible
    alter_table :surveys do
      rename_column :editable, :visible
    end

  end
end