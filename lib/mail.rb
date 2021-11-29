# frozen_string_literal: true

# This is a set of classes to query, retrieve, and send emails using the Microsoft
# Graph API.
#
# We need an access token to use the Graph API.  Instead of having to implement an
# OAuth2 authentication/authorization workflow, which would require running an actual web
# service, we're going to use Postman to retrieve the access token and store this
# as a local environment variable.
#
# The access token is a JWT issued by Microsoft for delegated authorization to access
# O365 resources. Be aware that the JWT is only valid for approximately 90 minutes before
# it needs to be renewed or a new one needs to be retrieved.
#
# Note that the issued at ('iat') and expiration ('exp') times are given in UTC, so
# we'll need to convert this to make sure that our token is still valid.

require 'http'
require 'json'
require 'jwt'

module Graph
  class Mail
    def initialize(client)
      @client = client
    end

    def folder(folder = 'inbox', params = {})
      @client.get("/me/mailFolders/#{folder}", params)
    end

    def retrieve_messages(folder = 'Inbox', params = {})
      @client.get("/me/mailFolders('#{folder}')/messages", params)
    end

    def send_message(message)
      @client.post('/me/sendMail', message)
    end

    def delete_message(message_id)
      @client.delete("/me/messages/#{message_id}")
    end
  end
end

module Graph
  class Client
    BASE_URL = 'https://graph.microsoft.com/v1.0'

    attr_reader :headers

    def initialize(token = nil)
      if token.nil?
        raise 'GRAPH_TOKEN environment variable is not defined' unless ENV['GRAPH_TOKEN']

        create_headers ENV['GRAPH_TOKEN']
      else
        create_headers token
      end
    end

    def create_headers(token)
      @headers ||= {}
      @headers[:Authorization] = "Bearer #{token}"
      @headers[:Accept] = 'application/json'
    end

    def get(path, params = {})
      HTTP[@headers].get(BASE_URL + path, params: params)
    end

    def post(path, body = {})
      HTTP[@headers].post(BASE_URL + path, json: body)
    end

    def delete(path)
      HTTP[@headers].delete(BASE_URL + path)
    end
  end
end
