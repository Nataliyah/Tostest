class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def set_testSession(test, word, lang)
    session[:test_id] = test.id
    session[:word_id] = word.id
    session[:question_count] = 1
    session[:points] = 0
    session[:lang] = lang
    session[:mode] = :check
  end
  
  def if_correct(word1, word2)
    result = (word1.eql? word2) ? 1 : 0
    return result
  end
  
  def fun_next_question(test_id, act_word_id)
    test = Test.find(test_id)
    words = test.words
    item = words.where("id > ?", act_word_id).first #znajduje wszystkie wieksze od aktualnego (podstawia pod pytajnik), a potem bierze pierwszy
    item ||= words.first #jesli nie bylo takiego, to podstaw pierwszy
    session[:word_id] = item.id
    session[:question_count] += 1
  end
  
  def fun_prev_question(test_id, act_word_id)
    test = Test.find(test_id)
    words = test.words
    item = words.where("id < ?", act_word_id).last #znajduje wszystkie mniejsze od aktualnego (podstawia pod pytajnik), a potem bierze ostatni
    item ||= words.last #jesli nie bylo takiego, to podstaw ostatni
    session[:word_id] = item.id
    session[:question_count] -= 1
  end
  
  
end
