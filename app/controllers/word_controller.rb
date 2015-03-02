#!/usr/bin/env ruby
$LOAD_PATH << './lib/assets'
require 'ApiCaller'

class WordController < ApplicationController
  
  def index
  end

  # Main method that handles word requests displays
  def show
  	word = params['query']

  	# If a word was entered, call the API
  	if word == '' || word.nil?
  		render 'no_word_entered'
  	else
  		@results = call_api(word)
  	end
  end


  def call_api(word)
	api_query =  "https://wordsapiv1.p.mashape.com/words/" + word
	api_key= YAML.load(File.open('config/secrets.yml'))['api']['key']
	connectAPI = ApiCaller.new
    results  =  connectAPI.http_get(api_query, api_key)
    return parse_results(results)
  end

  def parse_results(results)
  	# if results not json, render not found
  	begin
  		results = JSON.parse(results)  
		rescue JSON::ParserError => e  
  		render 'word_not_found'
  		return
	end 

	# if response is json but no results -> not found
	if results['results'].nil?
		render 'word_not_found'
	end

	return results
  end


end
