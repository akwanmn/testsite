require 'spec_helper'

describe Lounge::HomeController do
  render_views

  describe 'get :landing' do
    before do
      get :landing
    end

    it { should render_template 'landing'}
  end

  describe 'get :new' do
    before do
      get :new
    end

    it { should render_template 'index' }
  end

  describe 'get :signup' do
    before do
      get :signup
    end

    #it should fail
    its(:status) { should == 400 }
  end

  describe 'post :signup' do
    let(:valid_attributes) { {nickname: "duckrabbitjon",
                              user_profile_attributes: {first_name: "Jonathon",
                                                        last_name: "Jones",
                                                        address_street: "22576 Outer Drive",
                                                        address_city: "Dearborn",
                                                        address_state: "MI",
                                                        address_zip: "48843",
                                                        address_country: "US"},
                              email: "jjones.det@gmail.com",
                              password: "password",
                              password_confirmation: "password",
                              order: {card_number: "5427601777819011",
                                      card_verification: "577",
                                      card_expires_on: "08/2015"},
                              accepted_terms: "1"} }

    describe 'with valid attributes' do
      before do
        post :signup, user: valid_attributes
      end

      it { should redirect_to lounge_dashboard_index_path }
    end

    describe 'with invalid attributes' do
      before do
        post :signup, user: valid_attributes.merge({email: nil})
      end

      it { should render_template 'index' }
    end
  end
end
