class PagesController < ApplicationController
  require 'Token'
  require 'SFRequest'

  def index
    @access_token = Token::get_token
    unless @access_token.nil?
      @news_feed = SFRequest::get_news_feed
    end
  end

  def error
  end

  def search
    #it has to be longer than 2 letters
    unless params['s'].nil? || params['s'].length < 2
      unless Token::get_token.nil?
        @found_values = SFRequest::search params['s']
      else
        redirect_to :action => 'index'      
      end
    else
      flash[:message] = 'You need at least 2 letters'
      redirect_to :action => 'index'
    end
  end

end
