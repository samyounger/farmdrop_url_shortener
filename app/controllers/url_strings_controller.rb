class UrlStringsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def show
    long_url = UrlService.find_long_url(params[:id]).second
    redirect_to "http://#{long_url}", status: :moved_permanently
  end

  def create
    short_url = UrlService.create_short_url(params[:url])
    render json: { url: short_url.second, short_url: short_url.first }, status: :created
  end
end
