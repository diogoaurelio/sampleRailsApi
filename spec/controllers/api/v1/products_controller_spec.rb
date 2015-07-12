require 'spec_helper'

describe Api::V1::ProductsController do

  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it "returns the information about a reporter on a hash" do
      product_response = json_response[:product]
      expect(product_response[:title]).to eql @product.title
    end

    it { should respond_with 200 }

    it "has the user as an object embedded" do
      product_response = json_response[:product]
      expect(product_response[:user][:email]).to eql @product.user.email
    end
  end #describe

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :product }
      #get :index
    end

    context "when is not receiving any product_ids parameter" do
      before(:each) do
        get :index
      end
      it "returns 4 records from the database" do
        products_response = json_response
        expect(products_response[:products]).to have(4).items
      end
      it "returns the user object into each product" do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user]).to be_present
          expect(product_response[:title]).to be_present
          #http://api.market_place_api.dev/products
        end
      end
      it { should respond_with 200 }
    end
    
    context "when product_ids parameter is sent" do
      before(:each) do
        @user = FactoryGirl.create :user
        3.times { FactoryGirl.create :product, user: @user }
        get :index, product_ids: @user.product_ids
      end
      it "returns just the products that belong to the user" do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user][:email]).to eql @user.email
        end
      end
    end


  end #describe

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @product_attributes }
      end

      it "renders the json represnetation for the product record just created" do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql @product_attributes[:title]
      end

      it { should respond_with 201 }
    end #context

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_product_attributes = { title: "Smart tv", price: "Twelve dollars" }
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @invalid_product_attributes }
      end
      it "renders an errors json" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end
      it "renders the json errors on why the user could not be created" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end
      it { should respond_with 422 }
    end #context

  end #describe

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end
    context "when updating is successfully done" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id, product: { title: "A smart TV dude" }  }
      end
      it "renders the json represnetation for the updated product" do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql "A smart TV dude"
      end
      it { should respond_with 200 }
    end
    context "when updating is NOT successful" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id, product: { price: "something" }}
      end
      it "renders json represnetation for errors" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end
      it "renders json why product could not be created" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end
      it { should respond_with 422 }
    end
  end #decribe

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end
    context "when a product is successfully deleted" do
      before(:each) do
        delete :destroy, { user_id: @user.id, id: @product.id }
      end
      it { should respond_with 204 }
    end
  end

end
