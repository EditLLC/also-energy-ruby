module APIConnection
  def connection
    @connect = Savon.client do |globals|
      globals.wsdl "http://www.alsoenergy.com/WebAPI/WebAPI.svc?wsdl"
      globals.endpoint "https://www.alsoenergy.com/WebAPI/WebAPI.svc"
      globals.env_namespace :soapenv
      globals.namespaces("xmlns:als1" => "http://schemas.datacontract.org/2004/07/AlsoEnergyAPI.Data")
      globals.namespace_identifier :als
      globals.pretty_print_xml true
      globals.log true
    end
  end
end
