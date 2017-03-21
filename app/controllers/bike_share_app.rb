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
    # binding.pry
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
#----------------------------------------------------------------
#----------------------------------------------------------------
#----Trips Controller medthods down below---------------------------
#----------------------------------------------------------------
  get '/trips' do
    @trips = Trip.all

    erb :"trips/index"
  end
end
