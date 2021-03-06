require 'spec_helper'

describe UsersController do
  describe "GET 'index'" do
    let(:users){ (1..20).map{ Factory(:user) } }

    before { users; get :index }

    it { should respond_with(:success) }
    it { assigns[:users].should == users.take(10) }
  end

  describe "GET 'show'" do

    shared_examples_for 'reponse user' do
      before { get :show, :id => user.username }

      it { should respond_with(:success) }
      it { assigns[:user].should == user }
    end

    context "on the same logged in user" do
      login_user

      it_should_behave_like 'reponse user'
      it { assigns[:pair_request].should be_nil }
    end

    context "different from logged in user" do
      let(:user) { Factory(:user) }
      let(:logged_in_user) { Factory(:user, :username => 'test') }

      before { sign_in logged_in_user }

      it_should_behave_like 'reponse user'
      it 'should partner equal current view profile' do
        get :show, :id => user.username

        assigns[:pair_request].partner_id.should == user.id
      end
    end

    context "no log in" do
      let(:user) { Factory(:user) }

      it_should_behave_like 'reponse user'
      it { assigns[:pair_request].should be_nil }
    end
  end

  describe "PUT 'update'" do
    login_user

    before do 
      put :update, params
    end

    context "on the same logged in user" do
      let(:params) { {:id => user.username, :format => :json, :user => {:full_name => 'my name'}} }

      it { should respond_with(:redirect) }
      it { controller.current_user.full_name.should == params[:user][:full_name] }
    end

    context "different from logged in user" do
      let(:another_user) { Factory(:user, :username => 'another')}
      let(:params) { {:id => another_user.username, :format => :json, :user => {:full_name => 'my name'}} }

      it { should respond_with(:forbidden) }
    end
  end
end

