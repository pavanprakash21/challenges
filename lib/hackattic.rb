require 'faraday'
require 'colorize'
require 'oj'
require 'digest'

Dir[File.expand_path('hackattic/**/*.rb', __dir__)].each { |f| require f }

# Use this module to solve a problem
# Example: Hackattic.solve(challenge_name)
module Hackattic
  require 'pry'
  using Refinements::Inflector

  class << self
    def solve(challenge)
      challenge_normalized = challenge.to_s.underscore
      input = get(challenge_normalized)
      handler = Object.const_get("Hackattic::#{challenge_normalized.camelize}")
                      .new(input)
      solution = handler.call
      send_solution(challenge_normalized, solution)
    end

    def get(challenge)
      response = Faraday.get(url(challenge, 'problem'))
      Oj.load(response.body, symbol_keys: true)
    end

    def send_solution(challenge, solution)
      payload = Oj.dump(solution, mode: :compat)
      p payload
      response = Faraday.post(url(challenge, 'solve'), payload, content_type)
      puts response.body
    end

    private

    def url(challenge, mode)
      token_param = URI.encode_www_form(access_token: ENV['ACCESS_TOKEN'])
      path = "challenges/#{challenge}/#{mode}?#{token_param}&playground=1"
      URI.join(ENV['HACKATTIC_URL'], path).to_s
    end

    def content_type
      { 'Content-Type' => 'application/json' }
    end
  end
end
