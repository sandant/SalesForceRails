class AuthorizationsController < ApplicationController
  require 'json'
  require 'oauth2'
  require 'cgi'
  require 'Token'

  def client
    OAuth2::Client.new(
      '3MVG9zeKbAVObYjPWX7.1fNTRQweoQ2LPrwV7Xiqc5kwFLkkPbuyo9lI9fR7bCbB61nOZ5RTbG1m448xxJ65i', 
      '8239832435732356986', 
      :site => 'https://login.salesforce.com', 
      :authorize_path =>'/services/oauth2/authorize', 
      :access_token_path => '/services/oauth2/token'
    )
  end

  def oauth
    redirect_to client.web_server.authorize_url(
      :response_type => 'code',
      :redirect_uri => "http://#{request.host}:#{request.port}/authorizations/callback"
    )
  end

  def callback
    begin
      if Token::get_token.nil?
        Token::set_token client.web_server.get_access_token(params[:code], :redirect_uri => 
                                 "http://#{request.host}:#{request.port}/authorizations/callback", 
                                 :grant_type => 'authorization_code')
      end
      redirect_to :controller => 'pages', :action => 'index'
    rescue => msg
      redirect_to :controller => 'pages', :action => 'error', :e => msg
    end
  end

end
