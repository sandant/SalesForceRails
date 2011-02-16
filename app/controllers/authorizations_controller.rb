require 'authorization'
require 'token'

class AuthorizationsController < ApplicationController

  def oauth
    redirect_to Authorization::oauth request
  end

  def callback
    begin
      if Token::get_token.nil?
        Token::set_token Authorization::callback request, params[:code]
      end
      redirect_to :controller => 'pages', :action => 'index'
    rescue => msg
      redirect_to :controller => 'pages', :action => 'error', :e => msg
    end
  end

end
