require "json"
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:answer].upcase
    @letters = params[:letters].split

    if can_be_built_from_grid?(@word, @letters) && valid_english_word?
      @results = "The word is valid according to the grid and is an English word ✅"
    elsif can_be_built_from_grid?(@word, @letters)
      @results = "The word is valid according to the grid, but is not a valid English word ❌"
    else
      @results = "The word can’t be built out of the original grid ❌"
    end
  end

  def can_be_built_from_grid?(word, letters)
    word.chars.all? { |char| word.count(char) <= letters.count(char) }
  end

  def valid_english_word?
    url = "https://dictionary.lewagon.com/#{params[:answer]}"
    uri = URI.parse(url).read
    response = JSON.parse(uri)
    response["found"]
  end
end
