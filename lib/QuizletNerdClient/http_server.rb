
class HttpServer
  def listen
    @server = TCPServer.new('0.0.0.0', 8080)
    @session = @server.accept
    @request = @session.gets

    close
    requested_path
  end

  def requested_path
    # error url: http://localhost:8080/oauth2/callback?error=access_denied&error_description=The+user+denied+access+to+your+application&state=random_string
    return unless @request =~ /GET .* HTTP.*/
    @request.gsub(%r{GET \/}, '')
            .gsub(/ HTTP.*/, '')
            .strip[/code=(.*)/, 1]
  end

  def close
    @session.print "You can close this window and return to the script\r\n\r\n"
    @session.close
  end
end
