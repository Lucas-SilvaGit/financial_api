require 'rails_helper'

RSpec.describe Category, type: :model do
  it "validates creating valid category" do
    category = create(:category)
    
    expect(category).to be_valid
  end  
end
