require 'spec_helper'
#bundle exec rspec spec/controllers/api/v1/users_controller_spec.rb
describe Api::V1::UsersController do
  #After adding the support/request_helpers, can comment the next 2 lines (before(:each)):
  #before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1, #{ Mime::JSON }" }
  #before(:each) { request.headers['Content-Type'] = Mime::JSON.to_s }
  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id#, format: :json #not needed because Mime added in Request Headers
    end
    it 'returns the information about a reporter on a hash' do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end
    it { should respond_with 200 }
  end #describe

  describe 'POST #create' do
    context 'when it is successfully created' do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }#, format: :json #not needed because Mime added in Request Headers
      end
      it 'renders the json representation for the user record just created' do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
      end
      it { should respond_with 201 }
    end #context

    context 'when is not created' do
      before(:each) do
        #not including the email
        @invalid_user_attributes = { password: '12345678',
                                    password_confirmation: '12345678'  }
        post :create, { user: @invalid_user_attributes }#, format: :json #not needed because Mime added in Request Headers
      end
      it 'renders an errors json' do
        user_response = JSON.parse(response.body, symbolize_names: true )
        expect(user_response).to have_key(:errors)
      end
      it 'renders the json errors on why the user couldnt be created' do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
      it { should respond_with 422 }
    end #context
  end #describe

  describe "PATCH #UPDATE" do
    context "when it is successfully created" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { email: "newmail@example.com" } }#, format: :json #not needed because Mime added in Request Headers
      end
      it 'renders the json representation of the updated user' do
        user_response = json_response
        expect(user_response[:email]).to eql "newmail@example.com"
      end

      it { should respond_with 200 }
    end #context

    context "when it is not created" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { email: "badmail_example.com" } }#, format: :json #not needed because Mime added in Request Headers
      end
      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end
      it { should respond_with 422 }

    end #context

  end #describe

  describe "DELETE #Destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      delete :destroy, { id: @user.id }#, format: :json #not needed because Mime added in Request Headers
    end
    it { should respond_with 200 }

  end #describe

end
