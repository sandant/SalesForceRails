require 'rubygems'
require 'sinatra'
require 'oauth2'
require 'json'
require 'cgi'
require 'session'

enable :sessions

INSTANCE_URL = 'https://na8.salesforce.com';

# Monkey patch to correct the Authorization header
class OAuth2::AccessToken
    def request(verb, path, params = {}, headers = {})
      @client.request(verb, path, params, headers.merge('Authorization' => "OAuth #{@token}"))
    end
end

# Monkey patch to correct status handling
class OAuth2::Client
    def request(verb, url, params = {}, headers = {})
      if verb == :get || verb == :delete
        resp = connection.run_request(verb, url, nil, headers) do |req|
          req.params.update(params)
        end
      else
        resp = connection.run_request(verb, url, params, headers)
      end
      
      case resp.status
        when 200, 201, 204
          if json?
            return OAuth2::ResponseObject.from(resp)
          else
            return OAuth2::ResponseString.new(resp)
          end
        when 401
          e = OAuth2::AccessDenied.new("Received HTTP 401 during request.")
          e.response = resp
          raise e
        else
          e = OAuth2::HTTPError.new("Received HTTP #{resp.status} during request.")
          e.response = resp
          raise e
      end
    end
end

def client
  OAuth2::Client.new(
    '3MVG9zeKbAVObYjPWX7.1fNTRQweoQ2LPrwV7Xiqc5kwFLkkPbuyo9lI9fR7bCbB61nOZ5RTbG1m448xxJ65i', 
    '8239832435732356986', 
    :site => 'https://login.salesforce.com', 
    :authorize_path =>'/services/oauth2/authorize', 
    :access_token_path => '/services/oauth2/token'
  )
end

def showAccounts access_token
  response = JSON.parse(access_token.get("#{INSTANCE_URL}/services/data/v20.0/query/?q=#{CGI::escape('SELECT Name, Id from Account LIMIT 100')}"))

  output = ''
  response['records'].each do |record| 
    output += "#{record['Id']}, #{record['Name']}<br/>"
  end
  output += '<br/>'
end

def createAccount access_token, name
  response = JSON.parse(access_token.post("#{INSTANCE_URL}/services/data/v20.0/sobjects/Account/", "{\"Name\": \"#{name}\"}", {'Content-type' => 'application/json'}))

  response['id']
end

def showAccount access_token, id
  response = JSON.parse(access_token.get("#{INSTANCE_URL}/services/data/v20.0/sobjects/Account/#{id}"))

  output = ''
  response.each do |key, value|
    output += "#{key}:#{value}<br/>"
  end
  output += '<br/>'
end

def updateAccount access_token, id, new_name, city
  access_token.post("#{INSTANCE_URL}/services/data/v20.0/sobjects/Account/#{id}?_HttpMethod=PATCH", "{\"Name\":\"#{new_name}\",\"BillingCity\":\"#{city}\"}", {'Content-type' => 'application/json'})

  'Updated record<br/><br/>'
end

def deleteAccount access_token, id
  access_token.delete("#{INSTANCE_URL}/services/data/v20.0/sobjects/Account/#{id}")

  'Deleted record<br/><br/>'
end

def getResource access_token
  response = access_token.get("#{INSTANCE_URL}/services/data/v20.0/sobjects", {'Content-type' => 'application/json'}).to_s
end

def describeObject access_token, object
  response = access_token.get("#{INSTANCE_URL}/services/data/v21.0/sobjects/#{object}/describe")
end

def check_oauth
  unless session['oauth_token']
    redirect '#{request.host}:#{request.post}/oauth_error'
  end
end

get '/' do
"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
<html>
<head>
<meta http-equiv='Content-Type' content=\"text/html; charset=UTF-8\">
<title>REST/OAuth Example</title>
</head>
<body>
<a href='oauth'>Click here to retrieve contacts from Salesforce via REST/OAuth.</a>
</body>
</html>"
end

get '/oauth' do
  redirect client.web_server.authorize_url(
    :response_type => 'code',
    :redirect_uri => "http://#{request.host}:#{request.port}/oauth/callback"
  )
end

get '/oauth/callback' do
  begin
    unless session[:access_token].nil?
      session[:access_token] = client.web_server.get_access_token(params[:code], :redirect_uri => "http://#{request.host}:#{request.port}/oauth/callback", :grant_type => 'authorization_code')
    end
    redirect 'http://#{request.host}:#{request.port}/sticky_note'
  rescue => msg
    redirect 'http://#{request.host}:#{request.port}/oauth_error'
  end
end

get '/oauth_error' do
'holdsahdsahdsa'
end

get '/sticky_note' do
'jamonsi'
end
