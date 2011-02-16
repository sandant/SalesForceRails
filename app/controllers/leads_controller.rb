require 'token'
require 'sfrequest'

class LeadsController < ApplicationController
  
  def index
    if Token::get_token.nil?
      redirect_to :controller => 'pages', :action => 'index'      
    else
      @sobjects = SFRequest::get_sobjects 'Lead'
    end
  end

  def edit
    if Token::get_token.nil?
      redirect_to :controller => 'pages', :action => 'index'      
    else
      unless params['id'].nil?
        @sobject = SFRequest::get_sobject params['id'], 'Lead'
      else
        redirect_to :controller => 'pages', :action => 'index'
      end
    end  
  end

  def update
    unless params.nil?
      SFRequest::update_sobject params, 'Lead'
      flash[:message] = 'Updated leads'
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
