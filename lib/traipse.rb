require "traipse/version"

module Traipse
  
  SEPARATOR = '.'
  
  # Find a needle in a haystack using something akin to JSON dot syntax
  # ex: Traipse.find( data, 'cat.name' ) # similar to data['cat']['name']
  def self.find( object, path )
    return _find( object, path.split( SEPARATOR ) )
  end
  
  def self.find_with_keys( object, path )
    _find_with_keys( object, path.split( SEPARATOR ) )
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
  
  def self._find_with_keys( object, path, full_path=[], results={} ) # :nodoc:
    key, *rest = path
    full_path << key unless key == "*"
    
    # Handle wildcard hash keys
    if key == '*'
      object.keys.each do |subkey|
        results.merge! _find_with_keys( object, [ subkey, *rest ], full_path.dup )
      end
      return results.reject { |k,v| v.nil? }
    end

    # This is the end of the line, megatron.
    return { full_path.join(".") => object[key] } if rest.empty?
    
    # Traverse hashes and arrays
    case object[ key ]
    when Hash
      return _find_with_keys( object[ key ], rest, full_path )
    when Array
      if rest.first =~ /^\d+$/
        index = rest.shift.to_i
        results.merge! _find_with_keys( object[key][index], rest, full_path + [index] )
      else
        object[ key ].each_with_index do |obj, index|
          results.merge! _find_with_keys( obj, rest, full_path + [index] )
        end
      end
    end
    
    return results
  end
  
end
