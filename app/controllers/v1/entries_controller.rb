module V1
  class EntriesController < ApplicationController
    before_action :set_entry, only: [:show, :update, :destroy]

    # GET /entries
    def index
      filtered_entries = Entry.all
      filter_params = {
        description: "name",
        value: "value",
        date: "date",
        billed: "billed",
        entry_type: "entry_type",
        category_id: "category_id",
        account_id: "account_id"
      }
    
      filter_params.each do |param, field|
        if params[param].present?
          filtered_entries = filtered_entries.where("#{field} LIKE ?", "%#{params[param]}%")
        end
      end
    
      @entries = filtered_entries
    
      render json: @entries
    end
    
    # GET /entries/1
    def show
      render json: @entry
    end

    # POST /entries
    def create
      @entry = Entry.new(entry_params)

      if @entry.save
        @entry.account.calculate_balance

        render json: @entry, status: :created, location: v1_entry_url(@entry)
      else
        render json: @entry.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /entries/1
    def update
      if @entry.update(entry_params)
        @entry.account.calculate_balance
        
        render json: @entry
      else
        render json: @entry.errors, status: :unprocessable_entity
      end
    end

    # DELETE /entries/1
    def destroy
      @entry.destroy

      @entry.account.calculate_balance
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_entry
        @entry = Entry.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def entry_params
        params.require(:entry).permit(:description, :value, :date, :billed, :entry_type, :category_id, :account_id)
      end
  end
end