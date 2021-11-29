require 'mail'
require 'rspec'
require 'webmock/rspec'
require 'http'

BASE_URL = 'https://graph.microsoft.com/v1.0'
test_headers = { "Accept": "application/json",
                 "Authorization": "Bearer AK" }
test_params = { "test": "params" }
test_body = { "test": "body",
              "with": "data"}

describe Graph::Client do

  it 'create headers with correct format' do

    client = Graph::Client.new('AK')
    expect(client.headers).to eq(test_headers)

  end

  before do
    @client = Graph::Client.new('AK')
  end

  it '#get' do
    stub_request(:get, BASE_URL + '/test')
      .with(headers: test_headers, query: test_params)
    @client.get('/test', test_params)
    expect(a_request(:get, BASE_URL + '/test')
      .with(headers: test_headers, query: test_params)).to have_been_made
  end

  it '#post' do
    stub_request(:post, BASE_URL + '/test')
      .with(headers: test_headers, body: test_body)
    @client.post('/test', test_body)
    expect(a_request(:post, BASE_URL + '/test')
      .with(headers: test_headers, body: test_body)).to have_been_made
  end

  it '#delete' do
    stub_request(:delete, BASE_URL + '/test')
      .with(headers: test_headers)
    @client.delete('/test')
    expect(a_request(:delete, BASE_URL + '/test')
      .with(headers: test_headers)).to have_been_made
  end

end
    
