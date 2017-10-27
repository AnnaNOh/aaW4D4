class SessionsController < ApplicationController

  before_action :require_logged_in, only:[:destroy]
  before_action :require_logged_out, only:[:new, :create]

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )
    if user.nil?
      flash.now[:errors] = ["Incorrect credentials"]
      render :new
    else
      login!(user)
      redirect_to cats_url
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end



end
