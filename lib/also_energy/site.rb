module AlsoEnergy
  class Site
    include HashWrangler
    include Virtus.model

    attribute :id, Integer
    attribute :name, String
    attribute :latitude, Float
    attribute :longitude, Float
    attribute :city, String
    attribute :state, String
    attribute :time_zone, String
    attribute :dst, Boolean
    attribute :type, String

    def initialize(params = {})
      super(params)
    end

  end
end
