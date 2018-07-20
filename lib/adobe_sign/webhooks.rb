module AdobeSign
  class Webhooks < Utils::Endpoint
    def base
      '/webhooks'
    end

    def post(data)
      AdobeSign::Utils::Request.post_json(endpoint, data, headers)
    end

    def get(webhook_id, full = false)
      AdobeSign::Utils::Request.get(endpoint("/#{webhook_id}"), headers, full)
    end

    def delete(webhook_id)
      custom_headers = headers
      custom_headers['If-Match'] = etag(webhook_id)

      AdobeSign::Utils::Request.delete(endpoint("/#{webhook_id}"), custom_headers)
    end

    def etag(webhook_id)
      data = get(webhook_id, true)
      data.status == :ok ? data.headers[:etag].try(:first) : nil
    end
  end
end
