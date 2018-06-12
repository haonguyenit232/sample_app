class SessionsController < ApplicationController
  before_action :find_user, only: :create

  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      user_actived @user
    else
      flash.now[:danger] = t "sessions.fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def find_user
    @user = User.find_by email: params[:session][:email].downcase
  end
end
