shared_examples 'admin_panel' do
  context 'when user is not logged in' do
  end

  context "when a user is logged in" do
    it "returns http success" do
      get :index
      expect(response).to be_success
      pending 'Require authentication'
    end
  end
end