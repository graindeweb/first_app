class MicropostsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:destroy]

  def index
    respond_to do |format|
      format.html { redirect_to root_path }
      format.rss  { @microposts = Micropost.all(:limit => 100) }
    end
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Votre micropost a bien été ajouté"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end

  private
    def authorized_user
      @micropost = Micropost.find(params[:id])
      redirect_to root_path unless current_user?(@micropost.user)
    end
end