require 'sfrequest'

class AccountsController < ApplicationController

  def index
    @sobjects = SFRequest::get_sobjects 'Account'
  end

  def edit
    unless params['id'].nil?
      @sobject = SFRequest::get_sobject params['id'], 'Account'
    else
      redirect_to :controller => 'pages', :action => 'index'
    end
  end

  def update
    unless params.nil?
      SFRequest::update_sobject params, 'Account'
      flash[:message] = 'Updated account'
      redirect_to :action => 'edit', :id => params['Id']
    else
      redirect_to :controller => 'pages', :action => 'index'
    end
  end

  def delete
  end

  def show
  end

end
