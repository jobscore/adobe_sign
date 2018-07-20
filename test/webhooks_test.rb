require 'test_helper'

describe 'Webhooks Test' do
  let(:base_path) { 'https://api.na2.echosign.com/' }
  let(:token) { '3AAABLblqZhDDdHpao1l-dbMkMTqIREWrUSfLN0w89CoL21Ux4jrkzVaUlI4QA8o6sgGSgI82fajPYDvWn2aJtfP1i_20O23S' }

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
    let(:webhook_id) { 'CBJCHBCAABAACELRPAve9uNaqTnfZYY-uUyxtF5aG_DJ' }

    it 'should return response error when parameters are not sent properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('webhooks_delete_invalid', record: :all) do
        response = AdobeSign::Agreements.new(base_path, token).post(webhook_id)

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
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
