require 'token'
require 'sfrequest'

class AccountsController < ApplicationController

  def index
    if Token::get_token.nil?
      redirect_to :controller => 'pages', :action => 'index'      
    else
      @sobjects = SFRequest::get_sobjects 'Account'
    end
  end

  def edit
    if Token::get_token.nil?
      redirect_to :controller => 'pages', :action => 'index'      
    else
      unless params['id'].nil?
        @sobject = SFRequest::get_sobject params['id'], 'Account'
      else
        redirect_to :controller => 'pages', :action => 'index'
      end
    end  
  end

  def update
    unless params.nil?
      SFRequest::update_sobject params, 'Account'
      flash[:message] = 'Updated account'
      redirect_to :action => 'edit', :id => params['Id'], :type => params['Type']
    else
      redirect_to :controller => 'pages', :action => 'index'
    end
  end

  def delete
  end

  def show
  end

end
