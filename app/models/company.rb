class Company < ApplicationRecord
  has_rich_text :description
  VALID_EMAIL_REGEX = /^[a-zA-Z0-9\-\._%\+]{1,256}@getmainstreet.com/
  validates :zip_code, presence: true
  validates :email, format: {with: VALID_EMAIL_REGEX, :multiline => true, message: " :Please Enter your Email in example@getmainstreet.com format"}, allow_blank: true

  after_create :update_city_state
  after_update :update_city_state
  attr_accessor :state, :city

  def update_city_state
    @city = ZipCodes.identify(self.zip_code).try(:[], :city)
    @state = ZipCodes.identify(self.zip_code).try(:[],:state_name)
  end
end
