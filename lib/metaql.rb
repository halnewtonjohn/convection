# frozen_string_literal: true

require 'net/http'
require 'uri'

class Metaql
  module Schema
    def self.execute(query:, token:, variables: {})
      p token
      response =
        Net::HTTP.post(
          URI("#{Convection.config.metaphysics_api_url}"),
          { query: query, variables: variables }.to_json,
          'X-ACCESS-TOKEN' => token,
          'Content-Type' => 'application/json'
        )

      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
