class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def if_correct(word1, word2)
    result = (word1.eql? word2) ? 1 : 0
    return result
  end
  
end
