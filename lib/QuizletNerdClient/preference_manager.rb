
class PreferenceManager
  include Singleton

  def settings_file
    "#{Dir.home}/.qnc.conf"
  end

  def reset
    File.delete(settings_file) if File.exist?(settings_file)
  end

  def store(settings)
    File.open(settings_file, 'w') do |file|
      file.write(settings.to_yaml)
    end
  end

  def store_preferences(client_id, app_secret, username)
    settings = {}
    settings[:client_id]  = client_id
    settings[:app_secret] = app_secret
    settings[:username]   = username

    store(settings)
  end

  def store_token_hash(token)
    return nil unless File.exist?(settings_file)
    settings = YAML.load_file(settings_file)
    settings[:app_token] = token
    store(settings)
  end

  def client_id
    return nil unless File.exist?(settings_file)
    settings = YAML.load_file(settings_file)
    settings[:client_id]
  end

  def app_secret
    return nil unless File.exist?(settings_file)
    settings = YAML.load_file(settings_file)
    settings[:app_secret]
  end

  def app_token
    return nil unless File.exist?(settings_file)
    settings = YAML.load_file(settings_file)
    settings[:app_token]
  end

  def username
    return nil unless File.exist?(settings_file)
    settings = YAML.load_file(settings_file)
    settings[:username]
  end
end
