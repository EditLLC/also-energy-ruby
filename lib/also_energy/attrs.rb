module ReturnAttributes
  def attrs
    self.class.instance_methods(false).map{|attr| (attr.to_s).gsub("=", "")}.uniq
  end
end
