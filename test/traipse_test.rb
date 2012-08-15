require "../lib/traipse"
require "test/unit"



class TraipseTest < Test::Unit::TestCase
  
  DATA = {
    "name" => "Percival",
    "board" => {
      "name" => "cats"
    },
    "categories" => [
      { "name" => "animals" },
      { "name" => "kitties" },
      { "name" => "robots" },    
    ],
    "products" => {
      "shoes" => {
        "brands" => [
          { "name" => "converse" },
          { "name" => "adidas" },
          { "name" => "nike" }
        ]
      },
      "apparel" => {
        "brands" => [
          { "name" => "Calvin Klein" },
          { "name" => "Diesel" },
          { "name" => "Betsey Johnson" },
          { "name" => [ "Marc", "Ecko" ] },
          { "caltrops" => 'Yes Please' }
        ]
      }
    }
  }
  
  def test_can_find_top_level_values
    assert_equal ['Percival'], Traipse.find( DATA, 'name' )
  end
  
  def test_can_return_key_names_too
    matches = Traipse.find_with_keys( DATA, 'name' )
    assert_equal matches.keys, ["name"]
    assert_equal matches.values, ["Percival"]
  end
  
  def test_can_get_to_nested_values
    matches = Traipse.find_with_keys( DATA, 'board.name' )
    assert_equal matches.keys, ["board.name"]
    assert_equal matches.values, ["cats"]
  end
  
  def test_can_traverse_arrays
    matches = Traipse.find_with_keys( DATA, 'categories.name' )
    assert_equal ["categories.0.name", "categories.1.name", "categories.2.name"], matches.keys
    assert_equal ["animals", "kitties", "robots"], matches.values
  end
  
  def test_can_traverse_arrays_to_get_to_nested_values
    matches = Traipse.find_with_keys( DATA, 'products.shoes.brands.name' )
    assert_equal ["products.shoes.brands.0.name", "products.shoes.brands.1.name", "products.shoes.brands.2.name"], matches.keys
    assert_equal [ "converse", "adidas", "nike" ], matches.values
  end
  
  def test_can_handle_key_wildcards
    matches = Traipse.find_with_keys( DATA, 'products.*.brands.name' )
    assert_equal [ "converse", "adidas", "nike", "Calvin Klein", "Diesel", "Betsey Johnson", [ "Marc", "Ecko" ] ], matches.values
    assert_equal "products.shoes.brands.0.name", matches.keys.first
    assert_equal "products.apparel.brands.3.name", matches.keys.last
    
    matches = Traipse.find_with_keys( DATA, '*.name' )
    assert_equal [ "cats", "animals", "kitties", "robots" ], matches.values
    assert_equal "board.name", matches.keys.first
    assert_equal "categories.2.name", matches.keys.last
  end
  
  def test_can_do_multiple_wildcards
    matches = Traipse.find_with_keys( DATA, "products.*.brands.*" )
    assert_equal [ "converse", "adidas", "nike", "Calvin Klein", "Diesel", "Betsey Johnson", [ "Marc", "Ecko" ], 'Yes Please' ], matches.values
    assert_equal "products.shoes.brands.0.name", matches.keys.first
    assert_equal "products.apparel.brands.4.caltrops", matches.keys.last
  end
  
  def test_can_match_array_indexed_paths
    assert_equal [ "Marc", "Ecko" ], Traipse.find_with_keys( DATA, "products.apparel.brands.3.name").values.first
    assert_equal 'Yes Please', Traipse.find_with_keys( DATA, "products.apparel.brands.4.caltrops").values.first
  end
end