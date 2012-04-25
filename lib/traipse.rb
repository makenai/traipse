require "traipse/version"

module Traipse
  
  SEPARATOR = '.'
  
  # Find a needle in a haystack using something akin to JSON dot syntax
  # ex: Traipse.find( data, 'cat.name' ) # similar to data['cat']['name']
  def self.find( object, path )
    return _find( object, path.split( SEPARATOR ) )
  end
  
  def self._find( object, path, results=[] ) # :nodoc:
    key, *rest = path
    
    # Oops.. no key? Hands a path of '*'
    return [ object ] unless key

    # What happens if we miss a key?
    return [] unless object.is_a?( Hash )

    # Handle wildcard hash keys
    if key == '*'
      object.keys.each do |subkey|
        results += _find( object, [ subkey, *rest ] )
      end
      return results
    end

    # This is the end of the line, megatron.
    return [ object[ key ] ].compact if rest.empty?

    # Traverse hashes and arrays
    case object[ key ]
    when Hash
      return _find( object[ key ], rest )
    when Array
      object[ key ].each do |obj|
        results += _find( obj, rest )
      end
    end
    
    return results
  end
  
end
