module AdobeSign
  class Authentication

    ENDPOINT = '/oauth/token'

    attr_accessor :base_path

    def initialize(base_path)
      @base_path = base_path
    end

    def post(client_id, client_secret, code, redirect_uri)
      query = {
        client_id: client_id,
        client_secret: client_secret,
        code: code,
        redirect_uri: redirect_uri,
        grant_type: 'authorization_code'
      }

      AdobeSign::Utils::Request::post(@base_path + ENDPOINT, query)
    end
  end
end
