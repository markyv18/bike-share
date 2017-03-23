require 'Date'
require_relative '../spec_helper'

RSpec.describe Station do
  describe 'validations' do

    it 'is valid with a name, dock count, longitude, latitude and installation date' do
      station = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Turing Station', dock_count: 12, installation_date:  Date.parse('8/6/2013'))

      expect(station).to be_valid
    end

    it 'is invalid if its missing a latitude' do
      city = City.create(name: 'Denver')

      station = city.stations.create(long: -121.90178200000001, name: 'Cat Station', dock_count: 12, installation_date: Date.parse('8/6/2013'))

      expect(station).to_not be_valid
    end

    it 'is invalid if its missing a longitude' do
      city = City.create(name: 'Denver')

      station = Station.create(lat: 37.329732, name: 'We\'re cool!', dock_count: 12, city_id: 1, installation_date: Date.parse('8/6/2013'))

      expect(station).to_not be_valid
    end

    it 'is invalid if its missing a name' do
      city = City.create(name: 'Denver')

      station = Station.create(lat: 37.329732, long: -121.90178200000001,  dock_count: 12, city_id: 1, installation_date: Date.parse('8/6/2013'))

      expect(station).to_not be_valid
    end

    it 'is invalid if its missing a dock count' do
      city = City.create(name: 'Denver')

      station = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Turing Station', city_id: 1, installation_date: Date.parse('8/6/2013'))

      expect(station).to_not be_valid
    end

    it 'is invalid if its missing a installation date' do
      city = City.create(name: 'Denver')

      station = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Turing Station', dock_count: 12, city_id: 1)

      expect(station).to_not be_valid
    end

    it 'is invlaid with a duplicate name' do

      Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Turing Station', dock_count: 12, city_id: 1, installation_date:  Date.parse('8/6/2013'))
      station = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Turing Station', dock_count: 12, city_id: 1, installation_date:  Date.parse('8/6/2013'))

      expect(station).to_not be_valid
    end

  end

  describe 'attributes' do
    it 'should have a name, dock count, city and installation date' do
      station = Station.new

      expect(station).to respond_to(:name)
      expect(station).to respond_to(:dock_count)
      expect(station).to respond_to(:city)
      expect(station).to respond_to(:installation_date)
    end
  end

  describe 'dashboard methods' do

    before do
      city = City.create(name: 'Denver')

      city.stations.create!(lat: 37.329732, long: -121.90178200000001, name: 'Beth\'s Station', dock_count: 12, installation_date: Date.parse('8/8/2017'))
      city.stations.create!(lat: 2, long: 1, name: 'Sam\'s Station', dock_count: 2, installation_date: Date.parse('12/10/1986'))
      city.stations.create!(lat: 2, long: 1, name: 'Chris\' Station', dock_count: 12, installation_date: Date.parse('8/8/2016'))
      city.stations.create!(lat: 2, long: 1, name: 'Mark\'s Station', dock_count: 2, installation_date: Date.parse('8/8/2016'))

      @start_date = DateTime.strptime('8/29/2013 14:01', '%m/%d/%Y %k:%M')
      @end_date = DateTime.strptime('8/29/2013 14:23', '%m/%d/%Y %k:%M')

      trip_1 = Trip.create(duration: 24, start_date: start_date, end_date: end_date, subscription_type: 'subscriber', bike_id: 1, start_station_id: 1, end_station_id: 3)

      trip_2 = Trip.create(duration: 24, start_date: start_date, end_date: end_date, subscription_type: 'subscriber', bike_id: 1, start_station_id: 1, end_station_id: 3)

      trip_3 = Trip.create(duration: 24, start_date: start_date, end_date: end_date, subscription_type: 'subscriber', bike_id: 1, start_station_id: 1, end_station_id: 2)

      number_of_trips = [trip_1, trip_2, trip_3]
    end

    # it 'shows the total stations' do
    #   count = Station.total
    #
    #   expect(count).to eq(4)
    # end

    # it 'shows the average number of docks per station' do
    #   average = Station.find_average_docks
    #
    #   expect(average).to eq(7)
    # end
    #
    # it 'shows the highest number of docks at a station' do
    #   max_docks = Station.max_dock_count
    #
    #   expect(max_docks).to eq(12)
    # end

    # it 'shows the station(s) with the highest number of docks' do
    #   station_max_docks = Station.stations_with_most_docks
    #   stations = [Station.find(1), Station.find(3)]
    #
    #   expect(station_max_docks).to eq(stations)
    # end
    #
    # it 'shows the fewest number of docks at a station' do
    #   min_docks = Station.min_dock_count
    #
    #   expect(min_docks).to eq(2)
    # end

    # it 'shows the station(s) with the fewest number of docks' do
    #
    #   station_min_docks = Station.stations_with_fewest_docks
    #   stations = [Station.find(2), Station.find(4)]
    #
    #   expect(station_min_docks).to eq(stations)
    # end
    #
    # it 'shows the first installed station' do
    #   oldest = Station.oldest_stations
    #   sam = [Station.find(2)]
    #
    #   expect(oldest).to eq(sam)
    # end
  #
  #   it 'shows the most recently installed station' do
  #     newest = Station.newest_stations
  #     beth = [Station.find(1)]
  #
  #     expect(newest).to eq(beth)
  #   end
  # end
  #
  # it 'shows the number of rides started at this station' do
  #   station = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Turing Station', dock_count: 12, installation_date:  Date.parse('8/6/2013'))
  #
  #   station.start_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer')
  #
  #     expect(station.rides_started).to eq(1)
  # end



  # it 'shows the number of rides ended at this station' do
  #
  #   station = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Turing Station', dock_count: 12, installation_date:  Date.parse('8/6/2013'))
  #
  #   station.end_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer')
  #
  #   expect(station.rides_ended).to eq(1)
  # end

  # it 'shows Most frequent destination station for rides that start from this station' do
  #
  #   station_1 = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Turing Station', dock_count: 12, installation_date:  Date.parse('8/6/2013'))
  #
  #   station_2 = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Turing Station', dock_count: 12, installation_date:  Date.parse('8/6/2013'))
  #
  #
  #   station_1.end_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer')
  #
  #   station_1.end_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer')
  #
  #   station_2.end_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer')
  #
  #   expect(station_1.most_frequent_destination).to eq(2)
  #   expect(station_2.most_frequent_destination).to eq(1)
  # end

  # it 'shows Most frequent origination station for rides that ended at this station' do
  #
  #   station_1 = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Turing Station', dock_count: 12, installation_date:  Date.parse('8/6/2013'))
  #
  #   station_1.start_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer')
  #
  #   station_1.start_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer')
  #
  #   expect(station_1.most_frequent_origination).to eq(2)
  # end

  # it 'shows date with the highest number of trips started at this location' do
  #
  #
  # end
  #
  # it 'shows zip code with most frequent use' do
  #   station_1 = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Turing Station', dock_count: 12, installation_date:  Date.parse('8/6/2013'))
  #
  #   station_1.start_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer', zip_code: 96007)
  #
  #   station_1.start_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer', zip_code: 96007)
  #
  #   station_1.start_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer', zip_code: 96009)
  #
  #   expect(station_1.most_frequent_zip_code).to eq([96007])
  # end

#   it 'shows the bike ID most frequently starting a trip at this station' do
#
#     station_1 = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Turing Station', dock_count: 12, installation_date:  Date.parse('8/6/2013'))
#
#     station_1.start_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer', bike_id: 33)
#
#     station_1.start_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer', bike_id: 33)
#
#     station_1.start_trips.create(duration: 22, start_date:Date.parse('8/6/2013'), end_date: Date.parse('8/6/2013'), subscription_type: 'customer', bike_id: 44)
#
#     expect(station_1.most_bikes_starting_here).to eq([33])
  end
end
