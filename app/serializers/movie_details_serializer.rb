class MovieDetailsSerializer
  include JSONAPI::Serializer

  set_type :movie
  attributes :id, :title, :vote_average, :summary, :release_year, :total_reviews

  attribute :runtime do |object|
    object.formatted_runtime
  end

  attribute :genres do |object|
    object.genres_list
  end

  attribute :cast do |object|
    object.limited_cast
  end

  attribute :reviews do |object|
    object.limited_reviews
  end
end