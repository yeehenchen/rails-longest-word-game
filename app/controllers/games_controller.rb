require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @words = (0...10).map { ('A'..'Z').to_a.sample }
    @time = Time.now
  end

  def score
    # create a hash dictionary to store words frequency
    word_hash = Hash.new(0)

    # get words from params as string
    words = params[:words]
    words.split(//).each { |w| word_hash[w] += 1 }

    input = params[:input]
    input.upcase.split(//).each { |w| word_hash[w] -= 1 }

    result = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{input}").read)
    if !word_hash.values.all? { |v| v >= 0 }
      @result = "Sorry but #{input} can't be built out of #{words.split(//).join(',')}"
    elsif !result["found"]
      @result = "Sorry but #{input} does not seem to be a valid English word"
    else
      @result = "Congratulations! #{input} is a valid English word!"
    end

    # get time score using Time.parse to parse a string to time object
    @time = Time.now - Time.parse(params[:time])
  end
end
