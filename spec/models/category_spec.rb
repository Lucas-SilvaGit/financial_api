require 'rails_helper'

RSpec.describe Category, type: :model do
  it "is valid with a valid description" do
    category = create(:category)
    
    expect(category).to be_valid
  end  

  it "is invalid without a description" do
    category = build(:category, description: nil)
    
    expect(category).to_not be_valid
  end

  it 'validates uniqueness description' do
    category_first = create(:category, description: "my category")
    category_last = build(:category, description: "my category")

    expect(category_last).to_not be_valid
  end
end
