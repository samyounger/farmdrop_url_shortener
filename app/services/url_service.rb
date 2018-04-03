# save and retrieve matching urls to shortened urls
class UrlService
  attr_reader :long_url, :short_url

  def self.create_short_url(long_url)
    url_service = new(long_url: long_url)
    return url_service.shorten_url unless (matching_url = url_service.match_long_url)
    matching_url
  end

  def self.find_long_url(short_url)
    url_service = new(short_url: short_url)
    url_service.match_short_url
  end

  def initialize(args)
    @long_url  = format_url(args[:long_url])
    @short_url = args[:short_url]
  end

  def shorten_url
    short_url = generate_hex
    Rails.cache.fetch(short_url) { @long_url }
    [short_url, long_url]
  end

  def match_short_url
    all_urls.find { |short, long| short == @short_url }
  end

  def match_long_url
    all_urls.find { |short, long| long == @long_url }
  end

  def format_url(long_url)
    return unless long_url
    strings_to_remove = %w[https://www. http://www. https:// http://]
    to_remove         = strings_to_remove.find { |sub_str| long_url.include?(sub_str) }
    long_url.gsub(to_remove, '')
  end

  def generate_hex
    loop do
      hex = SecureRandom.hex(4)
      break hex unless Rails.cache.exist?(hex)
    end
  end

  def all_urls
    Rails.cache.instance_variable_get(:@data).map { |key,value| [key, value.value] }
  end
end
