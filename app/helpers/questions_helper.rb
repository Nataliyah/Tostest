module QuestionsHelper
  def helper_questionNr
    session[:question_count]
  end
  
  def helper_points
    session[:points]
  end

end