class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      self.current_user = @user # !! now logged in
      redirect_to :controller => "task", :action => "index"
    else
      render :action => 'new'
    end
  end

end
