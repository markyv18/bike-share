require_relative '../spec_helper'

RSpec.describe "When a user needs to delete an bike-station entry" do
  it 'they can destroy a bike station, with delete button' do

    station = Station.create(name: 'Turing Station', dock_count: 12, city: 'Denver', installation_date: Date.parse("8/6/2013"))

    visit "/stations/#{station.id}"

    click_on "Delete"

    expect(current_path).to eq('/stations')
    expect(page).to_not have_content(station.name)
  end
end