module AdobeSign
  class Refresh
    ENDPOINT = 'oauth/refresh'

    attr_accessor :base_path

    def initialize(base_path)
      @base_path = base_path
    end

    def post(client_id, client_secret, refresh_token)
      query = {
        refresh_token: refresh_token,
        client_id: client_id,
        client_secret: client_secret,
        grant_type: 'refresh_token'
      }

      AdobeSign::Utils::Request.post(@base_path + ENDPOINT, query)
    end
  end
end
