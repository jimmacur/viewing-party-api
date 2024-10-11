require 'rails_helper'

RSpec.describe Movie, type: :poro do
  describe 'Movie PORO' do
    let(:movie) { Movie.new(id: 122, title: "The Lord of the Rings: The Return of the King", vote_average: 8.5)}

    it 'exists and has attributes' do
      expect(movie).to be_a(Movie)
      expect(movie.id).to eq('122')
      expect(movie.title).to eq('The Lord of the Rings: The Return of the King')
      expect(movie.vote_average).to eq(8.5)
    end
  end
end
