class PagesController < ApplicationController
  require 'Token'
  require 'SFRequest'

  def index
    @title = 'Connecting SalesForce using Ruby on Rails'
    @subtitle = 'You have to connect with SalesForce'
    @access_token = Token::get_token
    unless @access_token.nil?
      @subtitle = 'You are connected with salesforce now'
      @news_feed = SFRequest::get_news_feed
    end
  end

  def error
    @title = 'It ocurred an error'
    @subtitle = 'hdshdsa'
  end

end
