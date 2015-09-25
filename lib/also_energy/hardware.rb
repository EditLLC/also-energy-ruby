module AlsoEnergy
  class HardWare
    include HashWrangler
    include Virtus.model

    attribute :device_code, String
    attribute :device_id, Integer
    attribute :device_num, Integer
    attribute :flags, String
    attribute :gateway_id, String
    attribute :hardware_id, Integer
    attribute :name, String
    attribute :site_id, Integer
    attribute :field_list, Array

    def initialize(params = {})
      super(params)
    end

  end
end
