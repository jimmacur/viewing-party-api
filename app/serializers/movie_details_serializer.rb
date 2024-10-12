class MovieDetailsSerializer
  include JSONAPI::Serializer

  set_type :movie
  attributes :id, :title, :vote_average, :summary

  attribute :release_year do |object|
    object.release_year
  end

  attribute :runtime do |object|
    object.formatted_runtime
  end

  attribute :genres do |object|
    object.genres_list
  end

  attribute :cast do |object|
    object.limited_cast
  end

  attribute :total_reviews do |object|
    object.total_reviews
  end

  attribute :reviews do |object|
    object.limited_reviews
  end
end