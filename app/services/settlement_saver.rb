module Services
  class SettlementSaver

    def self.create(params)
      send(:new, Settlement.new(string_id: params[:settlement][:string_id].downcase), params).send(:create)
    end

    def self.update(settlement, params)
      send(:new, settlement, params).send(:update)
    end

    private

    def initialize(settlement, params)
      @settlement = settlement
      @settlement_params = params[:settlement].symbolize_keys
      @settlement_pictures_params = Array.new(@settlement_params.delete(:pictures)).map(&:symbolize_keys)
      @settlement_pictures_ids = @settlement_pictures_params.map{ |picture_params| picture_params[:id].to_i }.uniq
      self
    end

    def create
      @settlement.set_fields(@settlement_params, [:name, :other_names, :creation_year, :town_id, :satellite_pictures], missing: :skip)
      if @settlement.valid?
        @settlement.save
        @settlement_pictures_params.each do |picture_params|
          unless picture_params[:url].empty?
            create_picture(picture_params)
          end
        end
        @settlement.reload
      end
    end

    def update
      DB.transaction do
        @settlement.lock!
        @settlement.set_fields(@settlement_params, [:name, :other_names, :creation_year, :town_id, :satellite_pictures], missing: :skip)

        @settlement.pictures.each do |picture|
          unless @settlement_pictures_ids.include?(picture.id)
            picture.destroy
          end
        end

        @settlement_pictures_params.each do |picture_params|
          unless picture_params[:url].empty?
            if !picture_params[:id].empty? && picture = Picture.first(id: picture_params[:id], settlement_id: @settlement.id)
              picture.set_fields(picture_params, [:year, :url], missing: :skip)
              picture.save if picture.valid? && picture.modified?
            else
              create_picture(picture_params)
            end
          end
        end

        if @settlement.valid? && @settlement.modified?
          changed_columns = @settlement.changed_columns.dup
          @settlement.save

          SurveySaver.update_settlement_info(@settlement, changed_columns)
        end
      end
    end

    def create_picture(picture_params)
      picture = Picture.new do |_picture|
        _picture.year = picture_params[:year]
        _picture.url = picture_params[:url]
        _picture.settlement_id = @settlement.id
      end
      picture.save if picture.valid?
    end

  end
end