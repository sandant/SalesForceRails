class SobjectsController < ApplicationController
  def index
  end

  def edit
    unless params['id'].nil?
      @sobject = SFRequest::get_sobject params['id'], params['type']
    else
      redirect_to :controller => 'pages', :action => 'index'
    end
  end

  def update
    unless params.nil?
      SFRequest::update_sobject params
      flash[:message] = 'Updated account'
      redirect_to :action => 'edit', :id => params['Id'], :type => params['Type']
    else
      flash[:message] = 'You need at least one object for make an update'
      redirect_to :controller => 'pages', :action => 'index'
    end
  end

  def delete
  end

  def show
  end

  def check_type type
    if type != 'Account' && type != 'Contact' && type != 'Lead'
      flash[:message] = 'Incorrect type ' + type
      redirect_to :controller => 'pages', :action => 'index'
    end
  end

end
