require "test_helper"

describe "Authentication Test" do
  let(:base_path) { 'https://secure.na2.echosign.com' }
  let(:client_id) { 'CLIENT_ID' }
  let(:client_secret) { 'CLIENT_SECRET' }

  let(:redirect_uri) { 'https://test.jobscore.com/adobesign/setup' }

  it 'should return response error when parameters is not send properly' do
    code = 'INVALID_CODE'

    VCR.use_cassette('authentication_invalid') do
      response = AdobeSign::Authentication.new(base_path).post(client_id, client_secret, code, redirect_uri)

      assert_equal :unauthorized, response.status
      assert_equal 'invalid_request', response.data['error']
      assert_equal 'invalid authorization code', response.data['error_description']
    end
  end

  it 'should response valid token when parameters is send properly' do
    code = 'VALID_CODE'

    VCR.use_cassette('authentication_valid') do
      response = AdobeSign::Authentication.new(base_path).post(client_id, client_secret, code, redirect_uri)

      assert_equal :ok, response.status
      assert_equal 'ACCESS_TOKEN', response.data['access_token']
      assert_equal 'REFRESH_TOKEN', response.data['refresh_token']
      assert_equal 'Bearer', response.data['token_type']
      assert_equal 3600, response.data['expires_in']
    end
  end
end
