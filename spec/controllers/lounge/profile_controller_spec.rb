require 'spec_helper'

describe Lounge::ProfileController do
  render_views

  let(:user) { Fabricate(:user) }

  describe 'get :match_criteria' do
    context 'without being signed in' do
      before do
        get :match_criteria
      end

      it { should redirect_to new_user_session_path }
    end

    context 'while signed in' do
      before do
        sign_in user
        get :match_criteria
      end

      it 'should assign the right user' do
        assigns(:user).should == user
      end
      it { should render_template 'match_criteria' }
    end
  end
end
