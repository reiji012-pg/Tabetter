class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "アカウント登録が完了しました！"
      redirect_to @user
    else
      render "new"
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "アカウント情報の更新が完了しました！"
      redirect_to @user
    else
      render "edit"
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "ユーザーの削除が完了しました！"
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    # before_action
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "ユーザーが正しくありません（不正なアクセスです）"
        redirect_to root_url
      end
    end
    
    def admin_user
      @user = User.find(params[:id])
      unless current_user.admin? && !current_user?(@user)
        flash[:danger] = "ユーザーが正しくありません（不正なアクセスです）"
        redirect_to root_url
      end
    end
end
