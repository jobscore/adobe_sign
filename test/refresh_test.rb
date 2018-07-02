require "test_helper"

describe "Refresh Token Test" do
  let(:base_path) { 'https://api.na2.echosign.com/' }
  let(:client_id) { 'CLIENT_ID' }
  let(:client_secret) { 'CLIENT_SECRET' }

  # let(:client_id) { 'CBJCHBCAABAA7l1Y_9WjpftvIUSyqcTe7Vs9x6ej03DV' }
  # let(:client_secret) { '7bfjZPScdmv_VA_Dvvyrtopo5ExldfwW' }

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
    # refresh_token = '3AAABLblqZhAtDhaLA1Tj7JD1Z7h9cOyR8Vhwywdm4hZWxs7sMjmkSqS-IZSvrYwHsBjtd7Z4vwQ*'

    VCR.use_cassette('refresh_valid') do
      response = AdobeSign::Refresh.new(base_path).post(client_id, client_secret, refresh_token)

      assert_equal :ok, response.status
      assert_equal 'NEW_ACCESS_TOKEN', response.data['access_token']
      assert_equal 'Bearer', response.data['token_type']
      assert_equal 3600, response.data['expires_in']

  #     # assert_equal '3AAABLblqZhAatVHoTKFapLdZNriMSNSVJ9hWgH02qgYSbEIIqTI2TxiB4Lx0VfObVB1NUwfJUHZlDRG373aMeDelYZSG_2W6', response.data['access_token']
  #     # assert_equal '', response.data['refresh_token']

  # {"access_token":"3AAABLblqZhBJCK8BB7uCsExEEJKBBhlF2_xsFR8xgdQjFqYMR3Iy6htyqAt29ljr7OH9epyR2ZeBNK-I2HL8dj28RLY-jK3J","token_type":"Bearer","expires_in":3600}
    end
  end
end
