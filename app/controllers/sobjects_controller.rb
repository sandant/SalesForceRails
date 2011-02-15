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
    flash[:message] = 'Updated account'
    redirect_to :controller => 'pages', :action => 'index'
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
