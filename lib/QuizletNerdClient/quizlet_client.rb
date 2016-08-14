
module QuizletNerdClient
  class QuizLetClient
    include Singleton
    def initialize
      @settings     = PreferenceManager.instance
      @client_id    = @settings.client_id
      @app_secret   = @settings.app_secret
      @client       = quizlet_oauth_client
      @api_token    = OAuth2::AccessToken.from_hash(@client, @settings.app_token) unless @settings.app_token.nil?
    end

    def quizlet_oauth_client
      OAuth2::Client.new(
        @client_id,
        @app_secret,
        site: 'https://quizlet.com',
        authorize_url: 'https://quizlet.com/authorize',
        token_url: 'https://api.quizlet.com/oauth/token',
        raise_errors: false
      )
    end

    def authorized?
      !@api_token.nil?
    end

    def authorize
      open_url_for_auth unless authorized?
    end

    def basic_auth
      Base64.encode64("#{@client_id}:#{@app_secret}")
    end

    def api_token(auth_code)
      @api_token = @client.auth_code.get_token(auth_code,
                                               redirect_uri: 'http://localhost:8080/oauth2/callback',
                                               headers: { 'Authorization' => "Basic #{basic_auth}" })
      @settings.store_token_hash(@api_token.to_hash)
    end

    def open_url_for_auth
      url = @client.auth_code.authorize_url(scope: 'read write_set write_group', state: 'random_string')
      Launchy.open(url)
    end

    def profile
      exit ERROR_UNAUTHORIZED unless authorized?
      response = @api_token.get("https://api.quizlet.com/2.0/users/#{@settings.username}")
      response.parsed
    end

    def classes
      exit ERROR_UNAUTHORIZED unless authorized?
      response = @api_token.get("https://api.quizlet.com/2.0/users/#{@settings.username}/classes")
      validate_response(response)
    end

    def sets
      exit ERROR_UNAUTHORIZED unless authorized?
      response = @api_token.get("https://api.quizlet.com/2.0/users/#{@settings.username}/sets")
      validate_response(response)
    end

    def terms(set)
      exit ERROR_UNAUTHORIZED unless authorized?
      response = @api_token.get("https://api.quizlet.com/2.0/sets/#{set}/terms")
      validate_response(response)
    end

    def add_term(set, term, definition)
      exit ERROR_UNAUTHORIZED unless authorized?
      response = @api_token.post("https://api.quizlet.com/2.0/sets/#{set}/terms", params: { 'term' => term, 'definition' => definition })
      validate_response(response)
    end

    def delete_term(set, term_id)
      exit ERROR_UNAUTHORIZED unless authorized?
      response = @api_token.delete("https://api.quizlet.com/2.0/sets/#{set}/terms/#{term_id}")
      validate_response(response)
    end

    def validate_response(response)
      return response.parsed if response.error.nil?
      puts "Error: #{response.error}"
      {}
    end

    def reset
      @settings.reset
    end
  end
end