module HashWrangler
  #credit to http://stackoverflow.com/questions/8301566/
  def find_in_hash(key, object=self, found=nil)
    if object.respond_to?(:key?) && object.key?(key)
      return object[key]
    elsif object.is_a? Enumerable
      object.find { |*a| found = find_in_hash(key, a.last) }
      return found
    end
  end
end
