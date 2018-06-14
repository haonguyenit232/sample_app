class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets.send_sucess"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_resets.send_fail"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("password_resets.blank"))
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = t "password_resets.reset_sucess"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return unless @user.nil?
    flash[:danger] = t "password_resets.user_not_found_msg"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])
    flash.now[:dange] = t "password_resets.notice_valid"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "password_resets.expire"
    redirect_to new_password_reset_url
  end
end
