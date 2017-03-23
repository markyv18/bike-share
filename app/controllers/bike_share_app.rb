class BikeShareApp < Sinatra::Base

  get '/' do
    erb :home
  end

  get '/stations' do
    @stations = Station.ordered

    erb :"stations/index"
  end

  get '/stations/new' do
    @stations = Station.new

    erb :"stations/new"
  end

  post '/stations' do
    city = City.create(name: params[:station][:city])
    params[:station].delete('city')
    city.stations.create(params[:station])

    redirect "/stations"
  end

  get '/stations/:id/edit' do
    @station = Station.find(params[:id])

    erb :"stations/edit"
  end

  put '/stations/:id' do
    city = Station.find(params[:id]).city
    city = City.update(city.id, name: params[:station][:city])
    params[:station].delete('city')
    @station = Station.update(params[:id], params[:station])

    redirect "/stations/#{@station.id}"
  end

  delete '/stations/:id' do
    @station = Station.destroy(params[:id])

    redirect '/stations'
  end

  get '/stations/:id' do
    @trips = Trip
    @station = Station.find(params[:id])
    @rides_started = @station.rides_started
    @rides_ended = @station.rides_ended
    @most_frequent_destination = @station.most_frequent_destination
    @most_frequent_origination = @station.most_frequent_origination
    @most_frequent_zip_code = @station.most_frequent_zip_code
    @most_bikes_starting_here = @station.most_bikes_starting_here

    erb :"stations/show"
  end

  get '/station-dashboard' do
    @station = Station
# perform logic here before passing to the view
    erb :"stations/dashboard"
  end

  get '/weather_conditions' do
    @weather_conditions = WeatherCondition.ordered

    erb :"weather_conditions/index"
  end

  get '/weather_conditions/new' do
    @weather_condition = WeatherCondition.new

    erb :"weather_conditions/new"
  end

  post '/weather_conditions' do
    weather = WeatherCondition.create(params[:weather_condition])

    redirect "/weather_conditions"
  end

  get '/weather_conditions/:id/edit' do
    @weather_condition = WeatherCondition.find(params[:id])

    erb :"weather_conditions/edit"
  end

  put '/weather_conditions/:id' do
    @weather = WeatherCondition.update(params[:weather_condition]).first

    redirect "/weather_conditions/#{@weather.id}"
  end

  delete '/weather_conditions/:id' do
    @weather = WeatherCondition.destroy(params[:id])

    redirect '/weather_conditions'
  end

  get "/weather-dashboard" do
    @trips_temp_data = WeatherCondition.trips_by_temperature
    @trips_precip_data = WeatherCondition.trips_by_precipitation
    @trips_wind_speed_data = WeatherCondition.trips_by_wind_speed
    @trips_visibility_data = WeatherCondition.trips_by_visibility

    erb :"weather_conditions/dashboard"
  end

  get '/weather_conditions/:id' do
    @weather_condition = WeatherCondition.find(params[:id])

    erb :"weather_conditions/show"
  end


  get '/trips-dashboard' do
    @average_duration = Trip.average_duration
    @longest_trips = Trip.longest_rides
    @shortest_trips = Trip.shortest_rides
    @popular_start_stations = Trip.most_popular_start_stations
    @popular_end_stations = Trip.most_popular_end_stations
    @pop_bike_trips_count = Trip.most_popular_bike_trips_count
    @pop_bikes = Trip.most_popular_bikes
    @least_pop_bike_trips_count = Trip.least_popular_bike_trips_count
    @least_pop_bikes = Trip.least_popular_bikes
    @total_subscribers = Trip.subscribers_count
    @subscribers_percentage = (Trip.subscribers_percentage * 100).to_i
    @total_customers = Trip.customers_count
    @customers_percentage = (Trip.customers_percentage * 100).to_i

    erb :"trips/dashboard"
  end

  get '/trips' do
    if Trip.count < 31
      @trips = Trip.ordered

      erb :"trips/index"
    else

      redirect '/trips/page/1'
    end
  end

  get '/trips/new' do
      @bikes = [1,2]
      @weatherconditions = [1,2]
      @stations = Station.all

      erb :"trips/new"
  end

  post '/trips' do
    trip = params['trip']
    Trip.create(duration: trip['duration'].to_i,
                start_date: DateTime.parse(trip['start_date']),
                end_date: DateTime.parse(trip['end_date']), subscription_type: trip['subscription_type'],
                bike_id: 1, # Bike.find_by(bin: trip['bike'])
                start_station_id: 1,
                end_station_id: 2)

    redirect '/trips'
  end

  get '/trips/page/:page' do
    @page_number = params["page"].to_i
    batch_start = ((params["page"].to_i - 1) * 30) + 1
    @trips = Trip.find_each(batch_size: 30, start: batch_start, finish: batch_start + 29)
    erb :"trips/page"
  end

  get '/trips/:id' do
    @trip = Trip.find(params[:id])

    erb :"trips/show"
  end

  get '/trips/:id/edit' do
    @trip = Trip.find(params[:id])
    @bikes = Bike.all
    @weatherconditions = [1, 2] # Fix!
    @stations = Station.all

    erb :"trips/edit"
  end

  put '/trips/:id' do
    id = params['id']
    trip = params['trip']
    bike = trip['bike']

    trip['start_station'] = Station.find_by(name: trip['start_station'])
    trip['end_station'] = Station.find_by(name: trip['end_station'])
    trip['bike'] = Bike.find_by(bin: trip['bike'])
    date = trip['start_date'].to_date

    trip['weather_condition'] = WeatherCondition.find_by(date: date)

    Trip.update(id, params['trip'])

    redirect "/trips/#{id}"
  end

  delete '/trips/:id' do
    id = params['id']
    Trip.delete(id)

    redirect '/trips'
  end
end
