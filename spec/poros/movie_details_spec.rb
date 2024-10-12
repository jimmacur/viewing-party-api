require 'rails_helper'

RSpec.describe MovieDetails, type: :poro do
  let(:movie_data) do
    JSON.parse(File.read('spec/fixtures/lotr_full_response.json'), symbolize_names: true)
  end

  let(:movie) { MovieDetails.new(movie_data) }

  describe '#initialize' do
    it 'initializes with movie data' do
      expect(movie.id).to eq(122)
      expect(movie.title).to eq("The Lord of the Rings: The Return of the King")
      expect(movie.release_date).to eq("2003-12-17")
      expect(movie.vote_average).to eq(8.482)
      expect(movie.runtime).to eq(201)
      expect(movie.genres).to eq(movie_data[:genres])
      expect(movie.credits).to eq(movie_data[:credits])
      expect(movie.reviews).to eq(movie_data[:reviews])
    end
  end

  describe '#formatted_runtime' do
    it 'returns formatted runtime' do
      expect(movie.formatted_runtime).to eq('3h 21m')
    end
  end

  describe '#limited_reviews' do
    let(:reviews_data) do
      {
        results: [
          { author: 'elshaarawy', content: 'very good movie 9.5/10', author_details: { rating: 9.5 } },
          { author: 'John Chard', content: 'Some birds aren\'t meant to be caged...', author_details: { rating: 8.0 } },
          { author: 'Chris Stuckmann', content: 'Masterpiece. 10/10', author_details: { rating: 10.0 } },
          { author: 'Jane Doe', content: 'An unforgettable experience.', author_details: { rating: 9.0 } },
          { author: 'Film Critic', content: 'Absolutely stunning visuals.', author_details: { rating: 9.3 } }
        ]
      }
    end

    let(:movie) { MovieDetails.new(reviews: reviews_data) }
    let(:limited_reviews) { movie.limited_reviews }
    let(:review) { limited_reviews.first }

    it 'returns up to 5 reviews' do
      expect(limited_reviews.count).to be <= 5
    end

    it 'returns reviews with the correct structure' do
      expect(review).to have_key(:author)
      expect(review).to have_key(:content)
      expect(review).to have_key(:rating)
    end

    it 'returns the correct content for a review' do
      expect(review[:author]).to eq('elshaarawy')
      expect(review[:content]).to eq('very good movie 9.5/10')
      expect(review[:rating]).to eq(9.5)
    end

    it 'does not return more than 5 reviews' do
      expect(limited_reviews.size).to be <= 5
    end
  end
end