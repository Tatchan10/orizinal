class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  def index
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
  @user = User.find(params[:id])
 
  #編集しようとしてるユーザーがログインユーザーとイコールかをチェック
  if current_user == @user
 
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を編集しました。'
      render :edit
    else
      flash.now[:danger] = 'ユーザー情報の編集に失敗しました。'
      render :edit
    end   
 
  else
    redirect_to root_url
  end
   
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :nickname, :detail)
  end
  
      # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    unless  current_user?(@user)
      flash[:danger] = "操作が受け付けられませんでした。"
      redirect_to(root_url)
    end
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
end
