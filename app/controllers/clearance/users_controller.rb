class Clearance::UsersController < Clearance::BaseController
    before_action :redirect_signed_in_users, only: [:create, :new]
    skip_before_action :require_login, only: [:create, :new], raise: false
attr_accessor :user     
    def index
        binding.pry
        @user=User
    end
  
    def new
      @user = user_from_params
      render template: "users/new"
    end
  
    def create
      @user = user_from_params
        user =@user
        binding.pry
      if @user.save
        sign_in @user
        # redirect_back_or url_after_create
        redirect_to users_path(@user)
      else
        render template: "users/new", status: :unprocessable_entity
        render json: [{}]
      end
    end
  
    private
  
    def redirect_signed_in_users
        binding.pry
      if signed_in?
       
      redirect_to Clearance.configuration.redirect_url
      end
    end
  
    def url_after_create
      Clearance.configuration.redirect_url
    end
  
    def user_from_params
      email = user_params.delete(:email)
      password = user_params.delete(:password)
  
      Clearance.configuration.user_model.new(user_params).tap do |user|
        user.email = email
        user.password = password
      end
    end
  
    def user_params
      params[Clearance.configuration.user_parameter] || Hash.new
    end
  end