# frozen_string_literal: true

module Requests
  module JsonHelpers
    def parsed_response_body
      JSON.parse(response.body, symbolize_names: true)
    end
  end

  module AuthorizationHelpers
    def log_in(user, password = nil)
      password ||= user.password
      post log_in_path, params: { user: { email: user.email, password: password } },
                        headers: { 'X-Requested-With' => 'XMLHttpRequest', 'Accept' => 'application/json' }
    end

    def xhr_headers
      { 'X-Requested-With' => 'XMLHttpRequest' }
    end

    def agent_headers(guid, token)
      { HTTP_TRACKER_AGENT_GUID: guid, HTTP_TRACKER_AGENT_TOKEN: token, 'Accept' => 'application/json' }
    end
  end
end
