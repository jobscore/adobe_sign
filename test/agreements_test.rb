require 'test_helper'

describe 'Agreements Token Test' do
  let(:base_path) { 'https://api.na2.echosign.com/' }
  let(:token) { 'VALID_ACCESS_TOKEN' }
  let(:agreement_id) { 'SOME_AGREEMENT_ID' }
  let(:record_mode) { :none }

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

      VCR.use_cassette('agreements_post_invalid', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).post(data)

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
      end
    end

    it 'should response a valid data when parameters is send properly' do
      VCR.use_cassette('agreements_post_valid', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).post(data)

        assert_equal :created, response.status
        assert response.data.key?('id')
      end
    end
  end

  describe '#signing_urls' do
    it 'should return response error when parameters is not send properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('agreements_signing_urls_invalid', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).signing_urls(agreement_id)

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
      end
    end

    it 'should response a valid data when parameters is send properly' do
      VCR.use_cassette('agreements_signing_urls_valid', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).signing_urls(agreement_id)

        assert_equal :ok, response.status
        assert response.data.key?('signingUrlSetInfos')
        assert response.data['signingUrlSetInfos'].first.key?('signingUrls')
        assert response.data['signingUrlSetInfos'].first['signingUrls'].first.key?('email')
        assert_equal 'test@jobscore.com', response.data['signingUrlSetInfos'].first['signingUrls'].first['email']
        assert response.data['signingUrlSetInfos'].first['signingUrls'].first.key?('esignUrl')
        assert response.data['signingUrlSetInfos'].first['signingUrls'].first['esignUrl'].start_with?('https://secure.na2.echosign.com')
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

      VCR.use_cassette('agreements_state_invalid', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).state(agreement_id, data)

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
      end
    end

    it 'should return error when id is not exists at AdobeSign' do
      agreement_id = 'UNEXISTENT_ID'

      VCR.use_cassette('agreements_state_not_found', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).state(agreement_id, data)

        assert_equal :not_found, response.status
        assert_equal 'INVALID_AGREEMENT_ID', response.data['code']
        assert_equal 'The Agreement ID specified is invalid', response.data['message']
      end
    end

    it 'state should response a valid data when parameters is send properly' do
      VCR.use_cassette('agreements_state_valid', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).state(agreement_id, data)

        assert_equal :no_content, response.status
        assert_equal({}, response.data)
      end
    end

    it 'should return error when agreement was already cancelled at AdobeSign' do
      VCR.use_cassette('agreements_state_conflict', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).state(agreement_id, data)

        assert_equal :conflict, response.status
        assert_equal 'AGREEMENT_ALREADY_CANCELLED', response.data['code']
        assert_equal 'The agreement being modified has already been cancelled.', response.data['message']
      end
    end
  end

  describe '#get' do
    it 'should return response error when parameters is not send properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('agreements_get_invalid', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).get(agreement_id)

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
      end
    end

    it 'should return response not_found when id is not exists at AdobeSign' do
      agreement_id = 'UNEXISTENT_ID'

      VCR.use_cassette('agreements_get_not_found', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).get(agreement_id)

        assert_equal :not_found, response.status
        assert_equal 'INVALID_AGREEMENT_ID', response.data['code']
        assert_equal 'The Agreement ID specified is invalid', response.data['message']
      end
    end

    it 'should response a valid data when parameters is send properly' do
      VCR.use_cassette('agreements_get_valid', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).get(agreement_id)

        assert_equal :ok, response.status
        assert response.data.key?('id')
        assert response.data.key?('name')
        assert response.data.key?('participantSetsInfo')
        assert response.data.key?('senderEmail')
        assert response.data.key?('createdDate')
        assert response.data.key?('signatureType')
      end
    end
  end

  describe '#etag' do
    it 'should return nil when parameters is not send properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('agreements_get_invalid', record: record_mode) do
        assert_nil AdobeSign::Agreements.new(base_path, token).etag(agreement_id)
      end
    end

    it 'should return nil when id is not exists at AdobeSign' do
      agreement_id = 'UNEXISTENT_ID'

      VCR.use_cassette('agreements_get_not_found', record: record_mode) do
        assert_nil AdobeSign::Agreements.new(base_path, token).etag(agreement_id)
      end
    end

    it 'should response a valid data when parameters is send properly' do
      VCR.use_cassette('agreements_get_valid', record: record_mode) do
        assert_equal 'VALID_ETAG_VALUE', AdobeSign::Agreements.new(base_path, token).etag(agreement_id)
      end
    end
  end

  describe '#documents' do
    it 'should response a valid data when parameters is send properly' do
      VCR.use_cassette('agreements_documents_valid', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).documents(agreement_id)

        assert_equal :ok, response.status
        assert response.data.key?('documents')
        assert response.data['documents'].first.key?('id')
        assert response.data['documents'].first.key?('name')
      end
    end

    it 'should return response not_found when id is not exists at AdobeSign' do
      agreement_id = 'UNEXISTENT_ID'

      VCR.use_cassette('agreements_documents_not_found', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).documents(agreement_id)

        assert_equal :not_found, response.status
        assert_equal 'INVALID_AGREEMENT_ID', response.data['code']
        assert_equal 'The Agreement ID specified is invalid', response.data['message']
      end
    end

    it 'should return response error when parameters is not send properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('agreements_documents_invalid', record: record_mode) do
        response = AdobeSign::Agreements.new(base_path, token).documents(agreement_id)

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
      end
    end
  end

  describe '#document' do
    it 'should return a file when document id exists for the agreement' do
      document_id = 'SOME_DOCUMENT_ID'
      tempfile = nil

      begin
        VCR.use_cassette('agreements_document_valid', record: record_mode) do
          tempfile = AdobeSign::Agreements.new(base_path, token).document(agreement_id, document_id)

          assert_instance_of Tempfile, tempfile
          assert_equal 96343, File.size(tempfile)
          assert_equal '.pdf', File.extname(tempfile)
        end
      ensure
        tempfile.try(:unlink)
      end
    end

    it 'should return nil when document id is not exists for the agreement' do
      document_id = 'UNEXIST_DOCUMENT_ID'

      VCR.use_cassette('agreements_document_not_found', record: record_mode) do
        assert_nil AdobeSign::Agreements.new(base_path, token).document(agreement_id, document_id)
      end
    end

    it 'should return nil when parameters is not send properly' do
      token = 'INVALID_TOKEN'
      document_id = 'SOME_DOCUMENT_ID'

      VCR.use_cassette('agreements_document_invalid', record: record_mode) do
        assert_nil AdobeSign::Agreements.new(base_path, token).document(agreement_id, document_id)
      end
    end
  end
end
