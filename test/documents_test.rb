require 'test_helper'

describe 'Document Test' do
  let(:base_path) { 'https://api.na2.echosign.com/' }
  let(:file) { File.new('test/fixtures/agreement.pdf', 'rb') }
  let(:record_mode) { :none }

  describe '#upload' do
    it 'should return response error when parameters is not send properly' do
      token = 'INVALID_TOKEN'

      VCR.use_cassette('documents_upload_invalid', record: record_mode) do
        response = AdobeSign::Documents.new(base_path, token).upload(file, 'document.pdf')

        assert_equal :unauthorized, response.status
        assert_equal 'INVALID_ACCESS_TOKEN', response.data['code']
        assert_equal 'Access token provided is invalid or has expired', response.data['message']
      end
    end

    it 'should response a valid data when parameters is send properly and document was uploaded gracefully' do
      token = 'VALID_ACESSS_TOKEN'

      VCR.use_cassette('documents_upload_valid', record: record_mode) do
        response = AdobeSign::Documents.new(base_path, token).upload(file, 'document.pdf')
        response_data = { 'transientDocumentId' => 'NEW_TRANSIENT_DOCUMENT_ID' }

        assert_equal :created, response.status
        assert_equal response_data, response.data
      end
    end
  end
end
