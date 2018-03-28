class UrlStringsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def show
    long_url = match_short.second
    redirect_to "http://#{long_url}", status: :moved_permanently
  end

  def create
    short_url = match_long || shorten_url
    render json: { url: short_url.second, short_url: short_url.first }, status: :created
  end

  private

  def shorten_url
    short_url = SecureRandom.hex(4)
    long_url  = format_url
    Rails.cache.fetch(short_url) { long_url }
    [short_url, long_url]
  end

  def match_short
    url = params[:id]
    all_urls.find { |short, long| short == url }
  end

  def match_long
    url = params[:url]
    all_urls.find { |short, long| long == url }
  end

  def format_url
    url               = params[:url]
    strings_to_remove = %w[https://www. http://www. https:// http://]
    to_remove         = strings_to_remove.find { |sub_str| url.include?(sub_str) }
    url.gsub(to_remove, '')
  end

  def all_urls
    Rails.cache.instance_variable_get(:@data).map{ |key,value| [key, value.value] }
  end
end
