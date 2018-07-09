require 'test_helper'

describe 'Agreements Token Test' do
  let(:base_path) { 'https://api.na2.echosign.com/' }
  let(:token) { 'VALID_ACESSS_TOKEN' }

  describe '#post' do
    let(:data) {
      {
        fileInfos: [{ transientDocumentId: 'TRANSIENT_DOCUMENT_ID' }],
        name: 'Document Title',
        participantSetsInfo: [{
          memberInfos: [{
            email: 'test@jobscore.com'
          }],
          order: 1,
          role: 'SIGNER'
        }],
        signatureType: 'ESIGN',
        state: 'IN_PROCESS'
      }
    }

    it 'should return response error when parameters is not send properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('agreements_post_invalid') do
        response = AdobeSign::Agreements.new(base_path, token).post(data)

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
      end
    end

    it 'should response a valid data when parameters is send properly' do
      VCR.use_cassette('agreements_post_valid') do
        response = AdobeSign::Agreements.new(base_path, token).post(data)
        response_data = { 'id' => 'NEW_AGREEMENT_ID' }

        assert_equal :created, response.status
        assert_equal response_data, response.data
      end
    end
  end

  describe '#signing_urls' do
    let(:agreement_id) { 'SOME_AGREEMENT_ID' }

    it 'should return response error when parameters is not send properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('agreements_signing_urls_invalid') do
        response = AdobeSign::Agreements.new(base_path, token).signing_urls(agreement_id)

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
      end
    end

    it 'should response a valid data when parameters is send properly' do
      VCR.use_cassette('agreements_signing_urls_valid') do
        response = AdobeSign::Agreements.new(base_path, token).signing_urls(agreement_id)

        response_data = {
          'signingUrlSetInfos' => [{
            'signingUrls' => [{
              'email' => 'test@jobscore.com',
              'esignUrl' => 'https://secure.na2.echosign.com/public/apiesign?pid=SOME_DOCUMENT_PID'
            }]
          }]
        }

        assert_equal :ok, response.status
        assert_equal response_data, response.data
      end
    end
  end
end
