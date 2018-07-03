module AdobeSign
  class Users < Utils::Endpoint
    def base
      '/users'
    end

    def list
      AdobeSign::Utils::Request.get(endpoint, headers)
    end
  end
end
