require './test/test_helper'

class EircodeAddressTest < Minitest::Test
  def test_exists
    assert Eircode::Address
  end

  def test_it_gives_back_too_many_addresses
    VCR.use_cassette('too_many_addresses') do
      results = Eircode::Address.search("priory")
      assert_equal Eircode::Results, results.class
      assert_equal 137, results.total_matches
      assert_equal nil, results.addresses
    end
  end

  def test_it_gives_back_no_addresses
    VCR.use_cassette('no_addresses') do
      results = Eircode::Address.search("sdsdsdsdsdsd")
      assert_equal Eircode::Results, results.class
      assert_equal 0, results.total_matches
      assert_equal nil, results.addresses
    end
  end

  def test_it_gives_back_some_addresses
    VCR.use_cassette('some_addresses') do
      results = Eircode::Address.search("the priory dublin")
      assert_equal Eircode::Results, results.class
      assert_equal 10, results.total_matches
      assert_equal Array, results.addresses.class
      first_address = results.addresses.first
      assert_equal Eircode::Address, first_address.class
    end
  end
end