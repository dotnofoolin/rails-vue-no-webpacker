class ExamplesController < ApplicationController
  def index
    @data = []
    10.times do
      @data.push generate_random_data
    end

    render json: @data
  end

  private

  def generate_random_data
    {
      name: Faker::Name.name,
      favorite_restaurant: Faker::Restaurant.name,
      favorite_movie: Faker::Movie.title,
      favorite_band: Faker::Music.band
    }
  end
end
