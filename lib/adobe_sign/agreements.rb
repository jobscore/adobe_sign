module AdobeSign
  class Agreements < Utils::Endpoint
    def base
      '/agreements'
    end

    def post(data)
      AdobeSign::Utils::Request.post_json(endpoint, data, headers)
    end
  end
end
