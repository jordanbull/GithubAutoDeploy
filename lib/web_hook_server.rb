require 'sinatra'
require 'json'

USER = 'user' # TODO: set username and password from private file
PASS = 'pass'

URL_PATH = '/deploy'

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [USER, PASS]
  end
end

post URL_PATH do
  if USER and PASS # does not require authentification if no user and password specified
    protected!
  end

  request.body.rewind
  data = JSON.parse request.body.read
  # TODO: script what should be done on github push here

end

