require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @voyelles = ["A", "E", "I", "O", "U", "Y"]
    @consonnes = ("A".."Z").to_a - @voyelles
    @letters = @voyelles.sample(3) + @consonnes.sample(7)
    @letters = @letters.shuffle!

  end

  def score
    @letters = params[:letters].split
    @word_chars = params[:word].upcase.chars
    @word = params[:word]
    @score = 0

    url = "https://dictionary.lewagon.com/#{params[:word]}"

    user_serialized = URI.open(url).read
    serialized_response = JSON.parse(user_serialized)

    if serialized_response["found"]
      if @word_chars.all? {|letter| @letters.include?(letter)}
        @message = "Congrats, you won #{@word.length} points"
        @score += @word.length
      else
        @message = "Your word does not match"
      end
    elsif @word.empty?
      @message = "There was no word"
    else
      @message = "Your word is not in the dictionary"

    end
  end
end
