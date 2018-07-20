require 'test_helper'

describe 'Webhooks Test' do
  let(:base_path) { 'https://api.na2.echosign.com/' }
  let(:token) { 'VALID_TOKEN' }

  describe '#post' do
    let(:data) {{
      name: 'E-signatures',
      scope: 'ACCOUNT',
      state: 'ACTIVE',
      webhookSubscriptionEvents: ['AGREEMENT_ALL'],
      webhookUrlInfo: {
        url: "https://webhook.url/adobesign"
      }
    }}

    it 'should return response error when parameters are not sent properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('webhooks_post_invalid') do
        response = AdobeSign::Agreements.new(base_path, token).post(data)

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
      end
    end

    it 'response a valid webhook_id when parameters is send properly' do
      VCR.use_cassette('webhooks_post_valid') do
        response = AdobeSign::Webhooks.new(base_path, token).post(data)
        response_data = { 'id' => 'WEBHOOK_ID' }

        assert_equal :created, response.status
        assert_equal response_data, response.data
      end
    end
  end

  describe '#delete' do
    let(:webhook_id) { 'WEBHOOK_ID' }

    it 'should return response error when using invalid token' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('webhooks_delete_invalid_token') do
        response = AdobeSign::Webhooks.new(base_path, token).delete(webhook_id)

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
      end
    end

    it 'should return response error when using invalid webhook id' do
      webhook_id = 'INVALID_WEBHOOK_ID'

      VCR.use_cassette('webhooks_delete_invalid_webhook_id') do
        response = AdobeSign::Webhooks.new(base_path, token).delete(webhook_id)

        assert_equal :not_found, response.status
        assert_equal 'INVALID_WEBHOOK_ID', response.data['code']
        assert_equal 'The webhook id specified is invalid.', response.data['message']
      end
    end

    it 'response a valid webhook_id when parameters is send properly' do
      VCR.use_cassette('webhooks_delete_valid') do
        response = AdobeSign::Webhooks.new(base_path, token).delete(webhook_id)

        assert_equal :no_content, response.status
      end
    end
  end
end
