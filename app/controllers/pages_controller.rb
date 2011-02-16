require 'token'
require 'sfrequest'

class PagesController < ApplicationController
  before_filter :check_token, :except => :index

  def index
    @access_token = Token::get_token
    unless @access_token.nil?
      @news_feed = SFRequest::get_news_feed
      @sticky_notes = SFRequest::get_sticky_notes
    end
  end

  def error
  end

  def search
    unless params['s'].nil? || params['s'].length < 2
      @found_values = SFRequest::search params['s']
    else
      flash[:message] = 'You need at least 2 letters'
      redirect_to :action => 'index'
    end
  end

end
