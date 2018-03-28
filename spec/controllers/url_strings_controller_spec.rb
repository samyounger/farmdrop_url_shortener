RSpec.describe UrlStringsController, type: :controller do
  describe '#post' do
    it 'successfully creates a new cached url' do
      post :create, params: { url: 'http://www.farmdrop.com' }
      parsed_response = JSON.parse(response.body)
      short_url       = parsed_response['short_url']

      expect(parsed_response).to eq ({ "url" => "farmdrop.com", "short_url" => short_url })
      expect(response).to have_http_status(:created)
    end
  end
  describe '#show' do
    it 'successfully redirects on finding the url' do
      post :create, params: { url: 'http://www.farmdrop.com' }
      parsed_response = JSON.parse(response.body)

      short_url = parsed_response['short_url']
      long_url  = parsed_response['url']

      get :show, params: { id: short_url }
      expect(response).to have_http_status(:moved_permanently)
    end
  end
end
