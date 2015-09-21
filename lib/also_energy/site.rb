module AlsoEnergy
  class Site
    include HashWrangler
    include ReturnAttributes

    attr_accessor :id, :name, :latitude, :longitude, :city, :state, :time_zone, :dst, :type

    def initialize
      yield(self) if block_given?
    end

  end
end
