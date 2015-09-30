require './test/test_helper'

describe AlsoEnergy::HardWare do

  soap_url = "https://www.alsoenergy.com/WebAPI/WebAPI.svc"
  wsdl_url = "http://www.alsoenergy.com/WebAPI/WebAPI.svc?wsdl"
  payload = { 'als1:DataField' => [ {'als1:FieldName' => 'UNIT', 'als1:Function' => 'FUNC', 'als1:HID' => 'HID'} ] }

  describe "the hardware data query process" do

    describe "#get_bin_data" do

      before do
        wsdl_query_fixture = YAML.load_file("test/fixtures/updated_wsdl.yml")
        stub_request(:get, wsdl_url).to_return(:body => wsdl_query_fixture["body"]["string"])
        @client = AlsoEnergy::Client.new do |c|
          c.session_id = 'SESSION_ID'
        end
        @hw = AlsoEnergy::HardWare.new(session_id: @client.session_id)
      end

      it "successfully returns hardware bin data from the API" do

        fixture = YAML.load_file("test/fixtures/also_energy_hardware_get_bin_data_success.yml")
        stub_request(:post, soap_url).with(:body => fixture["request"]["body"]["string"]
          ).to_return(:body => fixture["response"]["body"]["string"])

        @hw.get_bin_data("START", "END", "BIN", payload).wont_be_nil

      end

      it "raises an AlsoEnergy::QueryError if the get_bin_data is not successful" do

        fixture = YAML.load_file("test/fixtures/also_energy_hardware_get_bin_data_failure.yml")
        stub_request(:post, soap_url).with(:body => fixture["request"]["body"]["string"]
          ).to_return(:body => fixture["response"]["body"]["string"])


        assert_raises(AlsoEnergy::QueryError) do
          @hw.get_bin_data("START", "END", "BIN", payload)
        end

      end

    end
  end

end
