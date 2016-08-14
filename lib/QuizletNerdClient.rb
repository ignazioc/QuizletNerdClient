require 'rubygems'
require 'commander'
require 'yaml'
require 'launchy'
require 'socket'
require 'oauth2'
require 'singleton'
require 'oauth2/access_token'
require 'terminal-table'

require 'QuizletNerdClient/version'
require 'QuizletNerdClient/preference_manager'
require 'QuizletNerdClient/http_server'
require 'QuizletNerdClient/quizlet_client'

module QuizletNerdClient
  # Exit codes:
  ERROR_MISSING_PARAMETERS = 1
  ERROR_USER_CANCEL = 2
  ERROR_UNABLE_TO_AUTHORIZE = 3
  ERROR_UNAUTHORIZED = 4

  class Command


    include Commander::Methods

    def initialize
      @quizlet_client = QuizLetClient.instance
      @settings       = PreferenceManager.instance
    end

    def initialized?
      !(@settings.client_id.nil? || @settings.app_secret.nil?)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def run
      program :name, 'QuizletNerdClient'
      program :version, '0.0.1'
      program :description, 'Unofficial & unsupported command line client for Quizlet.com'

      # ===============================
      # RESET
      # ===============================
      command :reset do |c|
        c.syntax = 'quizlet reset'
        c.summary = 'Delete the ~/.qnc.conf file'
        c.description = c.summary
        c.action do |_args, _options|
          @quizlet_client.reset
        end
      end

      # ===============================
      # INIT
      # ===============================
      command :init do |c|
        c.syntax = 'qnc init'
        c.summary = 'Store the client-id, the app-secret and the username in ~/.quizlet.conf'
        c.description = c.summary
        c.example '', 'qnc init --client_id xxxx --app_secret yyyy --username zzzz'
        c.option '--clientid STRING',  String, 'Client id assigned from Quizlet'
        c.option '--appsecret STRING', String, 'App secret assigned from Quizlet'
        c.option '--username STRING',  String, 'Your Quizlet username'
        c.action do |_args, options|
          unless !options.appsecret.nil? && !options.clientid.nil?
            puts 'All the parameters are required.'
            exit ERROR_MISSING_PARAMETERS
          end

          if initialized?
            exit ERROR_USER_CANCEL unless agree('Overwrite your previous credentials? (Yes | No)')
          end

          @settings.store_preferences(options.clientid, options.appsecret, options.username)
        end
      end

      # ===============================
      # LOGIN
      # ===============================
      command :login do |c|
        c.syntax = 'qnc login'
        c.summary = 'Login on Quizlet.com and authorize this script'
        c.description = c.summary
        c.example '', 'qnc login'
        c.action do |_args, _options|
          unless initialized?
            puts "Missing configuration file.\nPlease run: 'qnc init --client_id xxxx --app_secret yyyy --username zzzz'"
            exit ERROR_MISSING_PARAMETERS
          end

          if @quizlet_client.authorized?
            puts "A token is already available, you don't need to login again. To login with different credentials un 'qnc reset'"
            exit 0
          end

          exit ERROR_USER_CANCEL unless agree('This script will open a new browser window, please login and authorize. Continue?  (Yes | No)')
          # Open a browser
          @quizlet_client.authorize

          # Start listening on port 8080
          auth_code = HttpServer.new.listen

          unless auth_code && !auth_code.empty?
            puts 'Unable to get an authorization code'
            exit ERROR_UNABLE_TO_AUTHORIZE
          end

          # Request an API Token using the auth code.
          @quizlet_client.api_token(auth_code)
          puts 'Token stored with success'
        end
      end

      # ===============================
      # GET PROFILE
      # ===============================
      command :profile do |c|
        c.syntax = 'qnc profile'
        c.summary = 'Work in progress'
        c.description = c.summary
        c.example 'description', 'qnc profile'
        c.action do |_args, _options|
          puts @quizlet_client.profile
        end
      end

      # ===============================
      # GET CLASSES
      # ===============================
      command :classes do |c|
        c.syntax = 'qnc classes'
        c.summary = 'Get the list of users\'s classes'
        c.description = c.summary
        c.example 'description', 'qnc classes'
        c.action do |_args, _options|
          result = @quizlet_client.classes.map { |klass| { id: klass['id'], name: klass['name'] } }

          table = Terminal::Table.new
          table.headings = %w(Id Name)
          result.each do |row|
            table.add_row [row[:id], row[:name]]
          end
          puts table
        end
      end

      # ===============================
      # GET SETS
      # ===============================
      command :sets do |c|
        c.syntax = 'qnc sets'
        c.summary = 'Get the list of user\'s sets'
        c.description = c.summary
        c.example 'description', 'qnc sets'
        c.action do |_args, _options|
          result = @quizlet_client.sets.map { |klass| { id: klass['id'], name: klass['title'] } }

          table = Terminal::Table.new
          table.headings = %w(Id Name)
          result.each do |row|
            table.add_row [row[:id], row[:name]]
          end
          puts table
        end
      end

      # ===============================
      # GET TERMS
      # ===============================
      command :terms do |c|
        c.syntax = 'qnc terms'
        c.summary = 'Get the list of terms in a specific set'
        c.description = c.summary
        c.example 'description', 'qnc terms --set 106787698'
        c.option '--set STRING', String, 'The set ID'
        c.action do |_args, options|
          result = @quizlet_client.terms(options.set).map { |klass| { id: klass['id'], term: klass['term'], definition: klass['definition'] } }

          table = Terminal::Table.new
          table.headings = %w(Id Term Definition)
          result.each do |row|
            table.add_row [row[:id], row[:term], row[:definition]]
          end
          puts table
        end
      end

      # ===============================
      # ADD TERM
      # ===============================
      command :add_term do |c|
        c.syntax = 'qnc add_term'
        c.summary = 'Add a term to a specific set'
        c.description = c.summary
        c.example 'description', 'qnc add_term --set 106787698 --term WORD --definition DEFINITION'
        c.option '--set STRING', String, 'The set ID'
        c.option '--term STRING', String, 'The term ID'
        c.option '--definition STRING', String, 'The definition ID'
        c.action do |_args, options|
          result = @quizlet_client.add_term(options.set, options.term, options.definition)

          table = Terminal::Table.new
          table.headings = %w(Id Term Definition)
          table.add_row [result['id'], result['term'], result['definition']]
          puts table
        end
      end

      # ===============================
      # DELETE TERM
      # ===============================
      command :delete_term do |c|
        c.syntax = 'qnc delete_term'
        c.summary = 'Delete a term from a specific set'
        c.description = c.summary
        c.example 'description', 'qnc delete_term --set 106787698 --term TERM_ID'
        c.option '--set STRING', String, 'The set ID'
        c.option '--term STRING', String, 'The term ID'
        c.action do |_args, options|
          result = @quizlet_client.delete_term(options.set, options.term)

        end
      end


      # rubocop:enable Metrics/CyclomaticComplexity

      run!
    end
  end
end
