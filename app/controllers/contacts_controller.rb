require 'token'
require 'sfrequest'

class ContactsController < ApplicationController

  def index
    if Token::get_token.nil?
      redirect_to :controller => 'pages', :action => 'index'      
    else
      @sobjects = SFRequest::get_sobjects 'Contact'
    end
  end

  def edit
    if Token::get_token.nil?
      redirect_to :controller => 'pages', :action => 'index'      
    else
      unless params['id'].nil?
        @sobject = SFRequest::get_sobject params['id'], 'Contact'
      else
        redirect_to :controller => 'pages', :action => 'index'
      end
    end  
  end

  def update
    unless params.nil?
      SFRequest::update_sobject params, 'Contact'
      flash[:message] = 'Updated contact'
      redirect_to :action => 'edit', :id => params['Id']
    else
      redirect_to :controller => 'pages', :action => 'index'
    end
  end

  def show
  end

  def delete
  end

end
