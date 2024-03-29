class WithdrawRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount, type: String
  field :to_address, type: String
  field :completed, type: Boolean, default: false

  belongs_to :user

  def self.with_user
    WithdrawRequest.includes(:user)
  end

  def complete
    self.completed = true
    self.save!
  end
end
