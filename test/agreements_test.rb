require 'test_helper'

describe 'Agreements Token Test' do
  let(:base_path) { 'https://api.na2.echosign.com/' }
  let(:token) { 'VALID_ACESSS_TOKEN' }
  let(:agreement_id) { 'SOME_AGREEMENT_ID' }

  describe '#post' do
    let(:data) {{
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
    }}

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

  describe '#state' do
    let(:data) {{
      state: 'CANCELLED',
      agreementCancellationInfo: {
        comment: 'Some comment',
        notifyOthers: false
      }
    }}

    it 'should return error when parameters is not send properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('agreements_state_invalid') do
        response = AdobeSign::Agreements.new(base_path, token).state(agreement_id, data)

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
      end
    end

    it 'should return error when id is not exists at AdobeSign' do
      agreement_id = 'UNEXIST_ID'

      VCR.use_cassette('agreements_state_not_found') do
        response = AdobeSign::Agreements.new(base_path, token).state(agreement_id, data)

        assert_equal :not_found, response.status
        assert_equal 'INVALID_AGREEMENT_ID', response.data['code']
        assert_equal 'The Agreement ID specified is invalid', response.data['message']
      end
    end

    it 'should return error when agreement was already cancelled at AdobeSign' do
      VCR.use_cassette('agreements_state_conflict') do
        response = AdobeSign::Agreements.new(base_path, token).state(agreement_id, data)

        assert_equal :conflict, response.status
        assert_equal 'AGREEMENT_ALREADY_CANCELLED', response.data['code']
        assert_equal 'The agreement being modified has already been cancelled.', response.data['message']
      end
    end

    it 'state should response a valid data when parameters is send properly' do
      VCR.use_cassette('agreements_state_valid') do
        response = AdobeSign::Agreements.new(base_path, token).state(agreement_id, data)

        assert_equal :no_content, response.status
        assert_equal({}, response.data)
      end
    end
  end

  describe '#get' do
    it 'should return response error when parameters is not send properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('agreements_get_invalid') do
        response = AdobeSign::Agreements.new(base_path, token).get(agreement_id)

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
      end
    end

    it 'should return response not_found when id is not exists at AdobeSign' do
      agreement_id = 'UNEXIST_ID'

      VCR.use_cassette('agreements_get_not_found') do
        response = AdobeSign::Agreements.new(base_path, token).get(agreement_id)

        assert_equal :not_found, response.status
        assert_equal 'INVALID_AGREEMENT_ID', response.data['code']
        assert_equal 'The Agreement ID specified is invalid', response.data['message']
      end
    end

    it 'should response a valid data when parameters is send properly' do
      VCR.use_cassette('agreements_get_valid') do
        response = AdobeSign::Agreements.new(base_path, token).get(agreement_id)

        response_data = {
          'id' => 'SOME_AGREEMENT_ID',
          'name' => 'Document Title',
          'participantSetsInfo' => [{
            'memberInfos' => [{
              'email' => 'signer@jobscore.com',
              'securityOption' => {
                'authenticationMethod' => 'NONE'
              }
            }],
            'role' => 'SIGNER',
            'order' => 1
          }],
          'senderEmail' => 'sender@jobscore.com',
          'createdDate' => '2018-07-10T21:43:57Z',
          'signatureType' => 'ESIGN',
          'locale' => 'en_US',
          'status' => 'IN_PROCESS',
          'documentVisibilityEnabled' => false
        }

        assert_equal :ok, response.status
        assert_equal response_data, response_data
      end
    end
  end

  describe '#etag' do
    it 'should return nil when parameters is not send properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('agreements_get_invalid') do
        assert_nil AdobeSign::Agreements.new(base_path, token).etag(agreement_id)
      end
    end

    it 'should return nil when id is not exists at AdobeSign' do
      agreement_id = 'UNEXIST_ID'

      VCR.use_cassette('agreements_get_not_found') do
        assert_nil AdobeSign::Agreements.new(base_path, token).etag(agreement_id)
      end
    end

    it 'should response a valid data when parameters is send properly' do
      VCR.use_cassette('agreements_get_valid') do
        assert_equal 'VALID_ETAG_VALUE', AdobeSign::Agreements.new(base_path, token).etag(agreement_id)
      end
    end
  end
end
