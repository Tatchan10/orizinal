class ToppagesController < ApplicationController
  def index
    if logged_in?
      @post = current_user.microposts.build  # form_for 用
      @posts = current_user.microposts.order('created_at DESC').page(params[:page])
    end
  end
end
