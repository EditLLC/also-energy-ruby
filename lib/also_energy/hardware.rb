module AlsoEnergy
  class HardWare
    include HashWrangler
    include APIConnection
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
    attribute :session_id, String

    def initialize(params = {})
      super(params)
    end

    def get_bin_data(period_start, period_end, bin_size, query_blob)
      message = {
                  'als:sessionID' => session_id,
                  'als:fromLocal' => period_start,
                  'als:toLocal' => period_end,
                  'als:binSize' => bin_size,
                  'als:Fields' => query_blob
                }
      response = find_in_hash(:data_set, (connection.call(:get_bin_data, message: message).body))
      response.nil? ? (fail QueryError, 'Query Failed!') : response
    end
  end
end
