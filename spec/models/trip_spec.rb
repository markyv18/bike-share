require_relative '../spec_helper'

RSpec.describe Trip do

  attr_reader :start_station,
    :end_station,
    :start_date,
    :end_date

  before do
    @start_date = DateTime.strptime('8/29/2013 14:01', '%m/%d/%Y %k:%M')
    @end_date = DateTime.strptime('8/29/2013 14:23', '%m/%d/%Y %k:%M')

    @start_station = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'Start Dummy', dock_count: 12, city_id: 1, installation_date: Date.parse('8/6/2013'))
    @end_station = Station.create(lat: 37.329732, long: -121.90178200000001, name: 'End Dummy', dock_count: 12, city_id: 1, installation_date: Date.parse('8/6/2013'))
  end

  describe 'validations' do
    it 'is valid with a duration, start_date, end_date, subscription_type, bike_id, start_station_id, end_station_id and weather_id' do

      trip = Trip.create(duration: 22, start_date: start_date, end_date: end_date, subscription_type: 'subscriber', bike_id: 1, start_station_id: 1, end_station_id: 2)

      expect(trip).to be_valid
    end

    it 'is invalid if its missing duration' do
      trip = Trip.create(start_date: '8/29/2013 14:01', end_date: '8/29/2013 14:23', subscription_type: 'subscriber', bike_id: 1, start_station_id: 1, end_station_id: 2)

      expect(trip).to_not be_valid
    end

    it 'is invalid if its missing start date' do
      trip = Trip.create(duration: 22, end_date: end_date, subscription_type: 'subscriber', bike_id: 1, start_station_id: 1, end_station_id: 2)

      expect(trip).to_not be_valid
    end

    it 'is invalid if its missing end date' do
      trip = Trip.create(duration: 22, start_date: start_date, subscription_type: 'subscriber', bike_id: 1, start_station_id: 1, end_station_id: 2)

      expect(trip).to_not be_valid
    end

    it 'is invalid if its missing subscription_type' do
      trip = Trip.create(duration: 22, start_date: start_date, end_date: end_date, bike_id: 1, start_station_id: 1, end_station_id: 2)

      expect(trip).to_not be_valid
    end

    it 'is invalid if it has a duplicate start_date and bike.' do
      bike = Bike.create(bin: 22)

      Trip.create(duration: 22, start_date: start_date, end_date: end_date, subscription_type: 'subscriber', bike: bike, start_station: start_station)

      trip = Trip.create(duration: 22, start_date: start_date, end_date: end_date, subscription_type: 'subscriber', bike: bike)

      expect(trip).to_not be_valid
    end
  end

  describe 'attributes' do
    it 'should have a duration, start_date, end_date, subscription_type, bike, start_station, end_station, start_date, end_date and weather_condition' do

      trip = Trip.new

      expect(trip).to respond_to(:duration)
      expect(trip).to respond_to(:start_date)
      expect(trip).to respond_to(:end_date)
      expect(trip).to respond_to(:subscription_type)
      expect(trip).to respond_to(:bike)
      expect(trip).to respond_to(:start_station)
      expect(trip).to respond_to(:end_station)
      expect(trip).to respond_to(:weather_condition)
    end
  end

  describe 'model methods' do
    attr_reader :trip1, :trip2, :start_station, :end_station

    before do
      @trip1 = Trip.create(duration: 22, start_date: start_date, end_date: end_date, subscription_type: 'subscriber', bike_id: 1, start_station_id: 1, end_station_id: 2)
      @trip2 = Trip.create(duration: 24, start_date: start_date, end_date: end_date, subscription_type: 'customer', start_station_id: 1, end_station_id: 2)
    end

    it 'can make its own name, with interpolation' do
      expect(trip1.make_name).to eq('8/29/2013: Start Dummy -> End Dummy')
    end

    it 'knows the average duration of trips' do
      expect(Trip.average_duration).to eq(23)
    end

    it 'knows its longest rides' do
      expect(Trip.longest_rides).to eq([trip2])
    end

    it 'knows its shortest rides' do
      expect(Trip.shortest_rides).to eq([trip1])
    end

    it 'knows the most popular starting station' do
      expect(Trip.most_popular_start_stations).to eq([start_station])
    end

    it 'knows the most popular end station' do
      expect(Trip.most_popular_end_stations).to eq([end_station])
    end

    # it 'knows the number of rides for a month' do
    #   expect('something').to eq('this')
    # end

    it 'knows the most popular bike and can count its rides' do
      bike1 = Bike.create(bin:1)
      bike2 = Bike.create(bin:2)

      bike1.trips << trip1
      bike2.trips << trip2
      bike2.trips << Trip.create(duration: 24, start_date: end_date, end_date: start_date, subscription_type: 'subscriber', start_station_id: 1, end_station_id: 2)


      expect(Trip.most_popular_bikes).to eq([bike2])
      expect(Trip.most_popular_bike_trips_count).to eq(2)
    end

    it 'knows the least popular bike and can count its rides' do
      bike1 = Bike.create(bin:1)
      bike2 = Bike.create(bin:2)

      bike1.trips << trip1
      bike2.trips << trip2
      bike2.trips << Trip.create(duration: 24, start_date: end_date, end_date: start_date, subscription_type: 'subscriber', start_station_id: 1, end_station_id: 2)


      expect(Trip.least_popular_bikes).to eq([bike1])
      expect(Trip.least_popular_bike_trips_count).to eq(1)
    end

    it 'knows about subscription types' do
      expect(Trip.subscribers_count).to eq(1)
      expect(Trip.subscribers_percentage).to eq(0.5)

      expect(Trip.customers_count).to eq(1)
      expect(Trip.customers_percentage).to eq(0.5)
    end

    # it 'knows what days had the most and least trips' do
    #   day1 = DateTime.strptime('8/27/2012 14:01', '%m/%d/%Y %k:%M')
    #   day2 = DateTime.strptime('8/28/2012 14:23', '%m/%d/%Y %k:%M')
    #   day3 = DateTime.strptime('8/29/2012 14:23', '%m/%d/%Y %k:%M')
    #
    #   trip1 = Trip.create(duration: 22, start_date: day1, end_date: end_date, subscription_type: 'subscriber')
    #   trip2 = Trip.create(duration: 22, start_date: day1, end_date: end_date, subscription_type: 'subscriber')
    #   trip3 = Trip.create(duration: 22, start_date: day1, end_date: end_date, subscription_type: 'subscriber')
    #   trip4 = Trip.create(duration: 22, start_date: day2, end_date: end_date, subscription_type: 'subscriber')
    #   trip5 = Trip.create(duration: 22, start_date: day2, end_date: end_date, subscription_type: 'subscriber')
    #   trip6 = Trip.create(duration: 22, start_date: day3, end_date: end_date, subscription_type: 'subscriber')
    #
    #   expect(Trip.busiest_days).to eq([day1])
    #   expect(Trip.busiest_day_trips_count).to eq(3)
    #   expect(Trip.slowest_days).to eq([day3])
    #   expect(Trip.slowest_day_trips_count).to eq(1)
    # end
  end

  describe "relationships" do
    it "every trip has one weather" do

      trip1 = Trip.create(duration: 23, start_date: @start_date, end_date: @end_date, subscription_type: 'subscriber')

      weather = WeatherCondition.create(max_temperature_f: 99.0, min_temperature_f: -121.9, mean_temperature_f: 55.0, mean_humidity: 62.5, mean_visibility_miles: 0.2, mean_wind_speed_mph: 20.0, precipitation_inches: 1.2, date: Date.parse('29/10/1986'))

      trip1.weather_condition = weather

      expect(trip1.weather_condition).to eq(weather)
    end
  end


end
