class UsersController < ApplicationController

  def new
  	@user = User.new
  end

  def show 
    @user = User.find(params[:id])
    unless session[:user_id] == @user.id
      flash[:notice] = "You don't have access to that order!"
      redirect_to user_path(session[:user_id])
      return
    end
  end

  def search
    @user = User.find(params[:id])
      unless session[:user_id] == @user.id
        redirect_to user_path(session[:user_id])
        return
      end
    final = Array.new
    similar_array = Array.new
    history = Array.new
    j=0
    lastfm = Lastfm.new(Rails.application.secrets.api_key, Rails.application.secrets.api_secret)
    if params[:submit]=="Search"
      term = params[:search]
      result = lastfm.artist.get_top_tracks(artist: term)
      similar = lastfm.artist.get_similar(artist: term)
      while j < result.size
        final<<result[j]["name"]
        j=j+1
      end
      j=1
      while j < similar.size
        similar_array<<similar[j]["name"]
        j=j+1
      end
      @result=final
      @similar=similar_array
    end
    @history = @user.histories.build(history: term)
    @history.save!
    @user.histories.each do |l|
      history << l.history
    end
    @history=history
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

   private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :submit, :search)
    end
end
