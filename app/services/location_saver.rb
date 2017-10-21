module Services
  class LocationSaver

    ALLOWED_UPDATE_FIELDS = {
      town: [:name, :poligon, :city_id],
      city: [:name, :poligon, :province_id],
      province: [:name, :poligon, :country_id]
    }.freeze

    def self.create(location_class, params)
      send(:new, location_class.new, params).send(:update)
    end

    def self.update(location, params)
      send(:new, location, params).send(:update)
    end

    private

    def initialize(location, params)
      @location = location
      @location_type = location.class.name.downcase.to_sym
      @location_params = params.symbolize_keys
      self
    end

    def update
      @location.set_fields(@location_params, ALLOWED_UPDATE_FIELDS[@location_type], missing: :skip)

      if @location.modified? && @location.valid?
        @location.save
      end
    end

  end
end