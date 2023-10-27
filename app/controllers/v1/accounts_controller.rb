module V1
  class AccountsController < ApplicationController
    before_action :authenticate_api_user!
    before_action :set_account, only: [:show, :update, :destroy]

    # GET /accounts
    def index
      filtered_accounts = current_api_user.account.all

      if params[:name].present?
        filtered_accounts = filtered_accounts.where("name LIKE ?", "%#{params[:name]}%")
      end

      if params[:balance].present?
        filtered_accounts = filtered_accounts.where(balance: params[:balance])
      end

      @accounts = filtered_accounts
      
      render json: @accounts
    end

    # GET /accounts/1
    def show
      render json: @account
    end

    # POST /accounts
    def create
      @account = current_api_user.account.new(account_params)

      if @account.save
        render json: @account, status: :created, location: v1_account_url(@account)
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /accounts/1
    def update
      if @account.update(account_params)
        render json: @account
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end

    # DELETE /accounts/1
    def destroy
      @account.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_account
        @account = current_api_user.account.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def account_params
        params.require(:account).permit(:name, :balance)
      end
  end
end