require 'offline_spec_helper'

feature 'First Login' do
  scenario 'prepare the app' do
    log_in_to_app(:Registration, :location =>  "Chandaiya CC - Kaliganj (10005345)") do
      sleep 10
    end
  end
end
