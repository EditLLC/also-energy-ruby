require './test/test_helper'

class AlsoEnergyTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::AlsoEnergy::VERSION
  end
end
