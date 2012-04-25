require 'spec_helper'

data = {
  "name" => "Percival",
  "board" => {
    "name" => "cats"
  },
  "categories" => [
    { "name" => "animals" },
    { "name" => "kitties" },
    { "name" => "robots" },    
  ],
  "products" => [
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
  ]
};

describe Traipse do

  it "can find top level values" do
    Traipse.find( data, 'name' ).should == [ 'Percival' ]
  end
  
  it "can get to nested values" do
    Traipse.find( data, 'board.name' ).should == [ 'cats' ]
  end
  
  it "can traverse arrays" do
    Traipse.find( data, 'categories.name' ).should == [ "animals", "kitties", "robots" ]
  end
  
  it "can traverse arrays to get to nested values" do
    Traipse.find( data, 'products.shoes.brands.name' ).should == 
      [ "converse", "adidas", "nike" ]
  end
  
  it "can handle key wildcards" do
    Traipse.find( data, 'products.*.brands.name' ).should ==
      [ "converse", "adidas", "nike", "Calvin Klein", 
        "Diesel", "Betsey Johnson", [ "Marc", "Ecko" ] ]
        
    Traipse.find( data, '*.name' ).should == ["cats"]
  end
  
  it "can do multiple wildcards" do
      Traipse.find( data, "products.*.brands.*" ).should == 
        [ "converse", "adidas", "nike", "Calvin Klein", 
          "Diesel", "Betsey Johnson", [ "Marc", "Ecko" ], 'Yes Please' ]
    end
  
end