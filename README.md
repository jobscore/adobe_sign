
# Jobscore AdobeSign Gem

This gem was made with ❤️ by Jobscore team. Hope you enjoy!

In this repository, you'll find the files you need to be able to package up your integration with AdobeSign REST for v6. While the oficial docs offers a complete guide, we miss a ruby way of building the integration. Althougth we found some other gems public available, they was not updated with the new v6. With this gem we hope to share our learnings and progress using the flavor of AdobeSign digital signature in our plataform.


Check the oficial [AdobeSign REST API](http://secure.na2.echosign.com/public/docs/restapi/v6) documentation for further details.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'adobe_sign', github: 'jobscore/adobe_sign'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install example-ruby-gem

## Usage

TODO: Write usage instructions here

### Authenticate

### Create an Agreeement

First, create a document with the signature fields

```ruby
document_service = AdobeSign::Documents.new(credentials['host'], credentials['access_token'])
response = document_service.upload(tempfile, 'some_file.docx')

return nil if response.status != :created

transient_document_id = response.data[:transientDocumentId]

```

Then, use the returned `transient_document_id` to create the agreement

```ruby
agreement_service = AdobeSign::Agreements.new(credentials['host'], credentials['access_token'])

  # Check API V6 for more attributes to customize the data signature request
  data = {
    fileInfos: [{ transientDocumentId: transient_document_id }],
    name: 'Jobscore Signature Request,
    participantSetsInfo: [{
      memberInfos: [{
        email: 'support@jobscore.com'
      }],
      order: 1,
      role: 'SIGNER'
    }],
    emailOption: {
      sendOptions: {
        completionEmails: 'NONE',
        inFlightEmails: 'NONE',
        initEmails: 'NONE'
      }
    },
    signatureType: 'ESIGN',
    state: 'IN_PROCESS'
  }

response = agreement_service.post(data)

return nil if response.status != :created

agreement_id = response.data[:id]

```

Now you can check on AdobeSign admin panel for the created file.

### Get Signature URL

After creating an agreement, you can fetch the sign link if necessary

```ruby
response = agreement_service.signing_urls(agreement_id)

return nil unless response.status == :ok
response.data[:signingUrlSetInfos].first[:signingUrls].first[:esignUrl]
```

### Cancel an Agreement

```ruby
data = {
  state: 'CANCELLED',
  agreementCancellationInfo: {
    comment: I18n.t('offer.esignatures.cancel_message', ats_user_full_name: @ats_user.full_name),
    notifyOthers: false
  }
}
agreement_service.state(agreement_id, data)

[:no_content, :conflict].include?(response.status)
```

### Update an Agreement

TBD

Currently we basicaly cancel the document and create a new. If you would like to implement this, fill free to fork and open a request ;)

### Refresh access token

When the token expire you need to refresh, here is a snippet:


```ruby
response = AdobeSign::Refresh.new(credentials['host']).post(
  ENV['ESIGNATURE_ADOBESIGN_CLIENT_ID'],
  ENV['ESIGNATURE_ADOBESIGN_CLIENT_SECRET'],
  credentials['refresh_token']
)

```ruby
Then, store the returned data for future requests

```ruby
credentials['access_token'] = response.data[:access_token]
credentials['expires_in'] = Time.zone.now + response.data[:expires_in]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jobscore/adobe_sign


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


