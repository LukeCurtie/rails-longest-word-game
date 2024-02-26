require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    unless @word.nil?
      @word = @word.upcase
      @letters = params[:letters].split
      if !word_in_grid?(@word, @letters)
        @message = "The word can't be built out of the original grid"
        return nil
      end

      @message = if english_word?(@word)
                  "The word is valid according to the grid, but is not a valid English word"
                 else
                  "The word is invalid according to the grid and is an English word"
                 end
    end
  end


  private

  def word_in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = Net::HTTP.get(URI("https://wagon-dictionary.herokuapp.com/#{word}"))
    json = JSON.parse(response)
    json['found']
  end
end
