# LAT LNG,

# POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))
# POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))
# MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)),((15 5, 40 10, 10 20, 5 10, 15 5)))
# MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)),((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),(30 20, 20 15, 20 25, 30 20)))

# POINT (30 10)
# LINESTRING (30 10, 10 30, 40 40)
# MULTIPOINT ((10 40), (40 30), (20 20), (30 10))
# MULTIPOINT (10 40, 40 30, 20 20, 30 10)
# MULTILINESTRING ((10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10))

require_relative '../helper'

class PolygonParserTest < Minitest::Test

  def test_valid_polygon_format_plain
    polygon = Services::PolygonParser.new("30 10, 40 40, 20 40, 10 20, 30 10")

    assert polygon.valid?
    refute polygon.has_errors?

    wkt_output = polygon.wkt
    assert wkt_output == "POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))"
  end

  def test_valid_polygon_format_simple_unlabeled
    polygon = Services::PolygonParser.new("((30 10, 40 40, 20 40, 10 20, 30 10))")

    assert polygon.valid?

    wkt_output = polygon.wkt
    assert wkt_output == "POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))"
  end

  def test_valid_polygon_format_complex_unlabeled
    polygon = Services::PolygonParser.new("((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))")

    assert polygon.valid?

    wkt_output = polygon.wkt
    assert wkt_output == "POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))"
  end

  def test_valid_polygon_format_simple
    polygon = Services::PolygonParser.new("POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))")

    assert polygon.valid?

    wkt_output = polygon.wkt
    assert wkt_output == "POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))"
  end

  def test_valid_polygon_format_simple_case_insensitive
    polygon = Services::PolygonParser.new("polygon ((30 10, 40 40, 20 40, 10 20, 30 10))")

    assert polygon.valid?

    wkt_output = polygon.wkt
    assert wkt_output == "POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))"
  end

  def test_valid_polygon_format_complex
    polygon = Services::PolygonParser.new("POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))")

    assert polygon.valid?

    wkt_output = polygon.wkt
    assert wkt_output == "POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))"
  end

  def test_valid_multipolygon_format_simple_unlabeled
    polygon = Services::PolygonParser.new("(((30 20, 45 40, 10 40, 30 20)),((15 5, 40 10, 10 20, 5 10, 15 5)))")

    assert polygon.valid?

    wkt_output = polygon.wkt
    assert wkt_output == "MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)),((15 5, 40 10, 10 20, 5 10, 15 5)))"
  end

  def test_valid_multipolygon_format_complex_unlabeled
    polygon = Services::PolygonParser.new("(((40 40, 20 45, 45 30, 40 40)),((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),(30 20, 20 15, 20 25, 30 20)))")

    assert polygon.valid?

    wkt_output = polygon.wkt
    assert wkt_output == "MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)),((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),(30 20, 20 15, 20 25, 30 20)))"
  end

  def test_valid_multipolygon_format_simple
    polygon = Services::PolygonParser.new("MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)),((15 5, 40 10, 10 20, 5 10, 15 5)))")

    assert polygon.valid?

    wkt_output = polygon.wkt
    assert wkt_output == "MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)),((15 5, 40 10, 10 20, 5 10, 15 5)))"
  end

  def test_valid_multipolygon_format_simple_case_insensitive
    polygon = Services::PolygonParser.new("MultiPolygon (((30 20, 45 40, 10 40, 30 20)),((15 5, 40 10, 10 20, 5 10, 15 5)))")
    assert polygon.valid?

    wkt_output = polygon.wkt
    assert wkt_output == "MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)),((15 5, 40 10, 10 20, 5 10, 15 5)))"
  end

  def test_valid_multipolygon_format_complex
    polygon = Services::PolygonParser.new("MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)),((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),(30 20, 20 15, 20 25, 30 20)))")

    assert polygon.valid?
    wkt_output = polygon.wkt
    assert wkt_output == "MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)),((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),(30 20, 20 15, 20 25, 30 20)))"
  end

  def test_valid_polygon_format_plain_reverse_coordinates
    polygon = Services::PolygonParser.new("30,10 40,40 20,40 10,20 30,10")

    assert polygon.valid?
    refute polygon.has_errors?

    wkt_output = polygon.wkt
    assert wkt_output == "POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))"
  end

  def test_invalid_polygon_format_plain_reverse_coordinates
    polygon = Services::PolygonParser.new("30,10 40,40)), ((20,40 10,20 30,10")

    refute polygon.valid?
    assert polygon.has_errors?
    assert polygon.errors.first.type == :estructure

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end
  end

  def test_invalid_polygon_labeled_malformed
    polygon = Services::PolygonParser.new("POLYGON (30 10, 40 40, 20 40, 10 20, 30 10))")
    refute polygon.valid?

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end

    polygon = Services::PolygonParser.new("MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)),((15 5, 40 10, 10 20, 5 10, 15 5))")
    refute polygon.valid?

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end
  end

  def test_invalid_polygon_labeled
    polygon = Services::PolygonParser.new("POINT (30 10)")
    refute polygon.valid?

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end

    polygon = Services::PolygonParser.new("LINESTRING (30 10, 10 30, 40 40)")
    refute polygon.valid?
    assert polygon.errors.first.type == :type

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end

    polygon = Services::PolygonParser.new("MULTIPOINT (10 40, 40 30, 20 20, 30 10)")
    refute polygon.valid?

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end

    polygon = Services::PolygonParser.new("MULTILINESTRING ((10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10))")
    refute polygon.valid?

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end
  end

  def test_invalid_polygon_unlabeled
    polygon = Services::PolygonParser.new("(30 10)")
    refute polygon.valid?

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end

    polygon = Services::PolygonParser.new("(30 10, 10 30, 40 40)")
    refute polygon.valid?

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end

    polygon = Services::PolygonParser.new("((10 40), (40 30), (20 20), (30 10))")
    refute polygon.valid?
    assert polygon.errors.first.type == :type

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end

    polygon = Services::PolygonParser.new("(10 40, 40 30, 20 20, 30 10)")
    refute polygon.valid?

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end

    polygon = Services::PolygonParser.new("((10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10))")
    refute polygon.valid?
    assert polygon.errors.first.type == :type

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end
  end

  def test_invalid_polygon_plain
    polygon = Services::PolygonParser.new("30 10")
    refute polygon.valid?

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end

    polygon = Services::PolygonParser.new("30 10, 10 30, 40 40")
    refute polygon.valid?
    assert polygon.errors.first.type == :type

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end

    polygon = Services::PolygonParser.new("(10 40), (40 30), (20 20), (30 10")
    refute polygon.valid?
    assert polygon.has_errors?
    assert polygon.errors.first.type == :estructure

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end

    polygon = Services::PolygonParser.new("(10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10)")
    refute polygon.valid?

    assert polygon.wkt.nil?
    assert_raises Services::PolygonParser::Error do
      polygon.wkt!
    end
  end

end
