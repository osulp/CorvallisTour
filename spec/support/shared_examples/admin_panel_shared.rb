shared_examples 'admin_panel' do
  context 'when user is not logged in' do
    it "should be unauthorized" do
      get :index
      expect(response.status).to eq 401 # Unauthorized
    end
  end

  context "when a user is logged in" do
    it "should return http success" do
      http_login
      get :index
      expect(response).to be_success
    end
  end
end