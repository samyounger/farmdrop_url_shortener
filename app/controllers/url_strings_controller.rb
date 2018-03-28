class UrlStringsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    long_url = match_short.second
    redirect_to long_url, status: :moved_permanently
  end

  def create
    short_url = match_long || shorten_url
    render json: { url: params[:url], short_url: short_url&.first }
  end

  private

  def shorten_url
    short_url = SecureRandom.hex(4)
    Rails.cache.fetch(short_url) { params[:url] }
    [short_url, params[:url]]
  end

  def match_short
    url = params[:id]
    all_urls.find { |short, long| short == url }
  end

  def match_long
    url = params[:url]
    all_urls.find { |short, long| long == url }
  end

  def all_urls
    Rails.cache.instance_variable_get(:@data).map{ |key,value| [key, value.value] }
  end
end
