class BikeShareApp < Sinatra::Base
  get '/stations' do
    @stations = Station.all

    erb :"stations/index"
  end

  get '/stations/:id' do
    @stations = Station.find(params[:id])

    erb :"stations/show"
  end
end
