class TestsController < ApplicationController
  helper_method :sort_column, :sort_direction #metody ktore musza zostac domyslnie zainicjalizowane (private) i maja byc dostepne dla sort_by w helperze aplikacji
  
  #############################################################
  
  def summary
  end
  
  def after_question
    case session[:mode]
      when :next_question then redirect_to :action => 'next_question', :future => 0, :result => params[:result], :answer => params[:answer]
      when :check then redirect_to :action => 'check', :future => 0, :result => params[:result], :answer => params[:answer]
      when :summary then redirect_to :action => 'summary'
    end
  end
  
  def check
    answer = params[:user_word]
    test = Test.find(session[:test_id])
    words = test.words
    word = words.find(session[:word_id])
    proper_word = (session[:lang]=='ang_pol') ? word.pol1 : word.ang
    result = if_correct(answer, proper_word)
    wstat = word.word_stat
    wstat ||= WordStat.create(session[:word_id], :count => 0, :correct => 0)
    wstat.count += 1
    if result==1
      wstat.correct += 1
    end
    wstat.save
  
    if (session[:question_count] >= test.words.count)
      session[:mode] = :summary
    else
      session[:mode] = :next_question
    end
    redirect_to :action => 'question', :future => 0, :result => result, :answer => answer
  end
  
  def next_question
    fun_next_question(session[:test_id], session[:word_id])
    session[:mode] = :check
    redirect_to :action => 'question'
  end
  
  def start_test
    test = Test.find(params[:id])
    words = test.words
    reset_session
    set_testSession(test, words.first, params[:lang])
    redirect_to :action => 'question', :future => 0
  end
    
  def question
    @test = Test.find(session[:test_id])
    correct = proper_word = (session[:lang]=='ang_pol') ? @test.words.find(session[:word_id]).pol1 : @test.words.find(session[:word_id]).ang
    @answer = params[:answer]
    
    flash[:notice] = nil
    flash[:error] = nil
    flash[:info] = nil
    flash[:answer] = nil
    
    @result = params[:result]
    @result ||= "-1"
      
    case @result
    when "0" then 
      flash[:error] = "Incorrect answer!"
      flash[:info] = "Correct answer was: " 
      flash[:answer] = correct
    when "1" then
      session[:points] += 1
      flash[:notice] = "Correct answer!"
    end
    
    case params[:future]
    when "1" then next_question(session[:test_id], session[:word_id])
    when "-1" then prev_question(session[:test_id], session[:word_id])
    end
    
    @word = Word.find(session[:word_id])
    
    @word_stat = { :count => 0, :correct => 0}
    if @word.word_stat != nil
      @word_stat[:count] = @word.word_stat.count
      @word_stat[:correct] = @word.word_stat.correct
    end
    
  end
  
  ############################################################
  
  def index
    @tests = Test.all #Test.order(sort_column + ' ' + sort_direction)  
  end
  
  def show
    @test = Test.find(params[:id])
    @word = Word.new(:test=>@test)
    @categories = Category.all
    #@word = @test.words.build
  end
  
  def new
    @test = Test.new
    @categories = Category.all
  end
  
  def edit
    @test = Test.find(params[:id])
    @word = Word.new(:test=>@test)
    @categories = Category.all
  end
  
  def create
    @test = Test.new(params[:test])
    @categories = Category.all
    
    respond_to do |format|
      if @test.save
        format.html { redirect_to @test, notice: 'Test was succesfully created.'}
      else
        format.html { render action: "new" }
      end
    end
  end
  
  def update
    @test = Test.find(params[:id])
    
    respond_to do |format|
      if @test.update_attributes(params[:test])
        format.html { redirect_to @test, notice: 'Test was succesfully updated.'}
      else
        format.html { render action: 'edit' }
      end
    end
  end
  
  def destroy
    @test = Test.find(params[:id])
    @test.destroy
    
    respond_to do |format|
      format.html { redirect_to tests_url }
    end
  end
  
  private
    
  def sort_column
    params[:sort] || "name"
  end
  def sort_direction
    params[:direction] || "asc"
  end
end
