module Services

  class PolygonParser
    class Error < StandardError
      attr_reader :type

      def initialize(error_type, error_message)
        @type = error_type
        super(error_message)
      end
    end

    attr_reader :errors

    def initialize(input_polygon_data)
      @input_polygon_data = input_polygon_data.strip.upcase
      @has_errors = false
      @errors = []
    end

    def wkt
      wkt!
    rescue PolygonParser::Error => e
      nil
    end

    def wkt!
      raise @errors.first unless valid?

      if declared_type.empty?
        case type
        when 'MULTIPOLYGON'
          polygon_data = extract_polygon_data(@input_polygon_data)
          "MULTIPOLYGON ((#{Array(polygon_data).join('),(')}))"
        when 'POLYGON'
          "POLYGON ((#{Array(@polygon_data).join('),(')}))"
        else
          nil
        end
      else
        @input_polygon_data
      end
    end

    def has_errors?
      @has_errors
    end

    def valid?
      unless valid_type?
        @has_errors = true
        @errors << Error.new(:type, 'El polígono ingresado no es de un tipo que soporta la plataforma. Únicamente puede ser POLYGON o MULTIPOLYGON en el formato WKT')
        return false
      end
      unless all_parenthesis_closed?
        @has_errors = true
        @errors << Error.new(:estructure, 'El polígono ingresado tiene paréntesis incompletos (no cerrados)')
        return false
      end
      true
    rescue
      @has_errors = true
      @errors << Error.new(:estructure, 'El polígono ingresado es inválido')
      false
    end

    private

    ALLOWED_POLYGON_TYPES = ['POLYGON', 'MULTIPOLYGON'].freeze
    MULTIPOLYGON_STRUCTURE_TYPE = /(\({3}.*\){3}|\({2}.*\){2}\s*\,\s*\({2}.*\){2})/.freeze
    POLYGON_STRUCTURE_TYPE = /(\({2}.*\){2}|\){1}\s*\,\s*\({1})/.freeze
    PARENTHESIS_PRESENCE = /(\(+|\)+)/.freeze

    def valid_type?
      ALLOWED_POLYGON_TYPES.include?(type)
    end

    def all_parenthesis_closed?
      return @all_parenthesis_closed unless @all_parenthesis_closed.nil?

      @all_parenthesis_closed = @input_polygon_data.count('(') == @input_polygon_data.count(')')
    end

    def type
      return @type unless @type.nil?

      @type = declared_type.empty? ? inferred_type : declared_type
    end

    def declared_type
      @declared_type ||= /([a-zA-Z]*)\s*\(*/.match(@input_polygon_data).captures[0]
    end

    def inferred_type
      case @input_polygon_data
      when MULTIPOLYGON_STRUCTURE_TYPE
        'MULTIPOLYGON'
      when POLYGON_STRUCTURE_TYPE
        @polygon_data = extract_polygon_data(@input_polygon_data)
        is_polygon?(@polygon_data) ? 'POLYGON' : 'OTHER'
      when PARENTHESIS_PRESENCE
        'OTHER'
      else
        @polygon_data = ensure_coordinates_format(@input_polygon_data)
        is_polygon?(@polygon_data) ? 'POLYGON' : 'OTHER'
      end
    end

    def is_polygon?(data)
      return @is_polygon unless @is_polygon.nil?

      @is_polygon = Array(data).all? do |polygon|
        coordinates = polygon.split(',').map(&:strip)
        (coordinates.length > 1 && coordinates.first == coordinates.last)
      end
    end

    def extract_polygon_data(polygon_data)
      data = /\(\((.*)\)\)/.match(polygon_data).captures[0]
      data.split(/\)\s*\,\s*\(/)
    end

    def ensure_coordinates_format(polygon_data)
      coordinates = polygon_data.split(',').map(&:strip)

      if coordinates.first.split(' ').length == 1
        polygon_data.split(' ').map do |coordinate|
          coordinate.strip!
          coordinate.split(',').map(&:strip).join(' ')
        end.join(', ')
      else
        polygon_data
      end
    end

  end
end
