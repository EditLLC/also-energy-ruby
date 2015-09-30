require './test/test_helper'

describe AlsoEnergy::HardWare do
  wsdl_query_fixture = YAML.load_file('test/fixtures/updated_wsdl.yml')

  def soap_request(fixture)
    stub_request(:post, 'https://www.alsoenergy.com/WebAPI/WebAPI.svc')
      .with(body: fixture['request']['body']['string'])
      .to_return(body: fixture['response']['body']['string'])
  end

  def wsdl_query(wsdl_query_fixture)
    stub_request(:get, 'http://www.alsoenergy.com/WebAPI/WebAPI.svc?wsdl')
      .to_return(body: wsdl_query_fixture['body']['string'])
  end

  payload = { 'als1:DataField' => [{ 'als1:FieldName' => 'UNIT', 'als1:Function' => 'FUNC', 'als1:HID' => 'HID' }] }

  describe 'the hardware data query process' do
    describe '#get_bin_data' do
      before do
        wsdl_query(wsdl_query_fixture)
        @client = AlsoEnergy::Client.new do |c|
          c.session_id = 'SESSION_ID'
        end
        @hw = AlsoEnergy::HardWare.new(session_id: @client.session_id)
      end

      it 'successfully returns hardware bin data from the API' do
        fixture = YAML.load_file('test/fixtures/also_energy_hardware_get_bin_data_success.yml')
        soap_request(fixture)

        @hw.get_bin_data('START', 'END', 'BIN', payload).wont_be_nil
      end

      it 'raises an AlsoEnergy::QueryError if get_bin_data is not successful' do
        fixture = YAML.load_file('test/fixtures/also_energy_hardware_get_bin_data_failure.yml')
        soap_request(fixture)

        assert_raises(AlsoEnergy::QueryError) do
          @hw.get_bin_data('START', 'END', 'BIN', payload)
        end
      end
    end
  end
end
