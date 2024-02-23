require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    search = JSON.parse(URI.open(url).read)

    @good = search["found"] && valid_word?(params[:word], params[:letters].split(""))
    error_massage = search["found"] ? "Sorry but #{params[:word]} can\'t be built out of #{params[:letters]}" : "Sorry but #{params[:word]} does not seem to be a valid English word..."
    message = @good ? "Well Done!" : error_massage
    @score = {
      score: @good ? (10 * params[:word].size ): 0,
      message: message
    }
  end

  private

  def generate_grid
    (0...10).map { rand(65..90).chr }
  end

  def valid_word?(word, grid)
    letters = word.upcase.chars
    grid.each do |letter|
      i = letters.index(letter)
      next if i.nil?

      letters.delete_at(i)
      return true if letters.empty?
    end
    false
  end
end
