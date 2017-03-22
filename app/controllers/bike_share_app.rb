require 'pry'

class BikeShareApp < Sinatra::Base
  get '/stations' do
    @stations = Station.all # What's AR's sorting method?

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
    @station = Station.find(params[:id])

    erb :"stations/show"
  end

  get '/station-dashboard' do
    @station = Station

    erb :"stations/dashboard"
  end

  get '/weather_conditions' do
    @weather_conditions = WeatherCondition.all

    erb :"weather_conditions/index"
  end

  get '/weather_conditions/new' do
    @weather_condition = WeatherCondition.new

    erb :"weather_conditions/new"
  end

  post '/weather_conditions' do
    @weather = WeatherCondition.create(params[:weather_condition])

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

  get '/weather_conditions/:id' do
    @weather_condition = WeatherCondition.find(params[:id])

    erb :"weather_conditions/show"
  end

end
