class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_post, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "microposts.create_sucess"
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.deleted"
    else
      flash[:danger] = t "microposts.deleted_fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_post
    @micropost = current_user.microposts.find_by id: params[:id]
    return unless @micropost.nil?
    flash[:danger] = t "microposts.wrong_user"
    redirect_to root_url
  end
end
