class UsersController < ApplicationController
  before_action :check_if_logged_out, only: [:new, :create, :forgot_password, :send_password_email, :reset_password, :save_new_password]
  before_action :check_if_logged_in, only: [:index]

  def index
    @users = User.all.order('score DESC')
  end

  # GET /forgot_password
  def forgot_password
  end

  # POST /forgot_password
  def send_password_email
    user = User.find_by_email(params[:email])

    unless user == nil
      UserMailer.forgot_password_email(user).deliver_now
      @message = 'Mail sent to ' + params[:email] + '.'
    else
      @message = 'No such e-mail address registered: ' + params[:email] + '.'
    end

    render 'forgot_password'
  end

  # GET /reset_password
  def reset_password
    @user = User.where(id: params[:id], password_reset_code: params[:reset_code]).first

    if @user == nil or params[:reset_code] == ''
      redirect_to forgot_password_path, notice: 'User does not exist or password reset code invalid.'
    end
  end

  # PATCH /reset_password
  def save_new_password
    @user = User.find(user_params[:id])

    if @user.update(user_params)
      @user.update(password_reset_code: nil)
      redirect_to login_path, notice: 'Your password has been successfully updated.'
    else
      render 'reset_password'
    end
  end

  # GET /users/new
  # GET /register
  def new
    @user = User.new
    @user.is_admin = false
    @user.score = 0

    if params[:name] != nil
      @user.username = params[:name]
    end

    if params[:gender] != nil
      @user.gender = params[:gender]
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.is_admin = false
    @user.score = 0
    @user.username.downcase!
    @user.email.downcase!

    if @user.save
      Region.all.each do |r|
        Manifest.create(region: r, user: @user, level: 0)
      end

      redirect_to login_path, notice: 'Successfully registered. You can log in now.'
    else
      render :new
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :email, :password, :password_confirmation, :username, :name, :gender, :college, :phone)
    end
end
