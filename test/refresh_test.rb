require 'test_helper'

describe 'Refresh Token Test' do
  let(:base_path) { 'https://api.na2.echosign.com/' }
  let(:client_id) { 'CLIENT_ID' }
  let(:client_secret) { 'CLIENT_SECRET' }

  it 'should return response error when parameters is not send properly' do
    refresh_token = 'INVALID_REFRESH_TOKEN'

    VCR.use_cassette('refresh_invalid') do
      response = AdobeSign::Refresh.new(base_path).post(client_id, client_secret, refresh_token)

      assert_equal :unauthorized, response.status
      assert_equal 'invalid_request', response.data['error']
      assert_equal 'invalid refresh token', response.data['error_description']
    end
  end

  it 'should response valid  when parameters is send properly' do
    refresh_token = 'VALID_REFRESH_TOKEN'

    VCR.use_cassette('refresh_valid') do
      response = AdobeSign::Refresh.new(base_path).post(client_id, client_secret, refresh_token)

      assert_equal :ok, response.status
      assert_equal 'NEW_ACCESS_TOKEN', response.data['access_token']
      assert_equal 'Bearer', response.data['token_type']
      assert_equal 3600, response.data['expires_in']
    end
  end
end
