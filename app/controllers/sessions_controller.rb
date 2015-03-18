class SessionsController < ApplicationController
  before_action :check_if_logged_out, only: [:new, :create]

  # GET /sessions/new
  # GET /login
  def new
  end

  # POST /sessions
  def create
    user = User.find_by_username(params[:username].downcase)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to zones_url
    else
      @error = "Looks like you've entered an invalid username or password."
      render 'new'
    end
  end

  # DELETE /sessions/1
  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
