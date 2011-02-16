require 'token'
require 'sfrequest'

class PagesController < ApplicationController

  def index
    @access_token = Token::get_token
    unless @access_token.nil?
      @news_feed = SFRequest::get_news_feed
    end
  end

  def error
    unless Token::get_token.nil?

    else
      redirect_to :action => 'index'      
    end
  end

  def search
    if Token::get_token.nil?
      redirect_to :action => 'index'      
    else
      unless params['s'].nil? || params['s'].length < 2
        @found_values = SFRequest::search params['s']
      else
        flash[:message] = 'You need at least 2 letters'
        redirect_to :action => 'index'
      end
    end
  end

end
