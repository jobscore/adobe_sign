require "test_helper"

describe 'Users Test' do
  let(:base_path) { 'https://api.na2.echosign.com/' }

  describe '#list' do
    it 'should return response error when parameters is not send properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('user_list_invalid') do
        response = AdobeSign::Users.new(base_path, token).list

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data[:code]
        assert_equal 'Access token provided is invalid or has expired', response.data[:message]
      end
    end

    it 'should response valid when parameters is send properly' do
      token = 'VALID_TOKEN'

      VCR.use_cassette('user_list_valid') do
        response = AdobeSign::Users.new(base_path, token).list

        assert_equal :ok, response.status
        assert response.data[:userInfoList].is_a?(Array)
        assert_equal 1, response.data[:userInfoList].count

        info = response.data[:userInfoList].first

        assert_equal 'test@jobscore.com', info[:email]
        assert_equal 'Jobscore', info[:company]
        assert_equal 'USER_ID', info[:id]
        assert_equal 'User', info[:firstName]
        assert_equal 'Name', info[:lastName]
        assert info[:isAccountAdmin]
      end
    end
  end
end
