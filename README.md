
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

## Usage

TODO: Write usage instructions here

### Authenticate

The API use the standard oAUTH2 to authenticate. Here we skip the basic protocol description, but you can find the usefull commands to initiate the authentication and fetch the access tokens:
```ruby
api_client = AdobeSign::Authentication.new('https://secure.na2.echosign.com/oauth/token')

response = api_client.post(
  'ADOBESIGN_CLIENT_ID',
  'ADOBESIGN_CLIENT_SECRET',
  'code',
  'redirect_uri'
)
```

When sucessfull, the response will include these fields that you should store for later requests:

```ruby
access_token = response.data[:access_token],
refresh_token = response.data[:refresh_token],
expires_in = Time.zone.now + response.data[:expires_in]
```

### Create an Agreeement

First, create a document with the signature fields

```ruby
document_service = AdobeSign::Documents.new('https://api.na2.echosign.com/', 'VALID_ACESSS_TOKEN')
response = document_service.upload(tempfile, 'some_file.docx')

return nil if response.status != :created

transient_document_id = response.data[:transientDocumentId]

```

Then, use the returned `transient_document_id` to create the agreement

```ruby
agreement_service = AdobeSign::Agreements.new('https://api.na2.echosign.com/', 'VALID_ACESSS_TOKEN')

# Check API V6 for more attributes to customize the data signature request
data = {
  fileInfos: [{ transientDocumentId: transient_document_id }],
  name: 'Jobscore Signature Request',
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
    comment: 'Awesome comment',
    notifyOthers: false
  }
}
agreement_service.state(agreement_id, data)

[:no_content, :conflict].include?(response.status) # no_content => true/success. conclict => already canceled
```

### Update an Agreement

TBD

Currently we basicaly cancel the document and create a new. If you would like to implement this, fill free to fork and open a request ;)

### Refresh access token

When the token expire you need to refresh, here is a snippet:


```ruby
response = AdobeSign::Refresh.new('https://api.na2.echosign.com/').post(
  'ADOBESIGN_CLIENT_ID',
  'ADOBESIGN_CLIENT_SECRET',
  refresh_token
)
```

Then, store the returned data for future requests

```ruby
access_token = response.data[:access_token]
expires_in = Time.zone.now + response.data[:expires_in]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jobscore/adobe_sign


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


