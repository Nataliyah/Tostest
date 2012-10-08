class TestsController < ApplicationController
  helper_method :sort_column, :sort_direction #metody ktore musza zostac domyslnie zainicjalizowane (private) i maja byc dostepne dla sort_by w helperze aplikacji
  
  #############################################################
  
  def check
    answer = params[:user_word]
    test = Test.find(params[:test_id])
    words = test.words
    word = words.find(params[:id])
    proper_word = (session[:lang]=='ang_pol') ? word.pol1 : word.ang
    result = if_correct(answer, proper_word)
    wstat = word.word_stat
    wstat ||= WordStat.create(:word_id => word.id, :count => 0, :correct => 0)
    wstat.count += 1
    if result==1
      wstat.correct += 1
    end
    wstat.save
    redirect_to :action => 'question', :test_id => test.id, :id => word.id, :future => 0, :result => result, :answer => answer
  end
  
  def start_test
    test = Test.find(params[:id])
    words = test.words
    reset_session
    session[:question_count] = 1
    session[:points] = 0
    session[:lang] = params[:lang]
    redirect_to :action => 'question', :test_id => test.id, :id => words.first.id, :future => 0
  end
    
  def question
    @test = Test.find(params[:test_id])
    correct = proper_word = (session[:lang]=='ang_pol') ? @test.words.find(params[:id]).pol1 : @test.words.find(params[:id]).ang
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
    
    item_id = params[:id]
    case params[:future]
    when "1" then item_id = next_question(params[:test_id], params[:id]); session[:question_count] += 1;
    when "-1" then item_id = prev_question(params[:test_id], params[:id])
    end
    
    @word = @test.words.find(item_id)
    
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
    #@word = @test.words.build
  end
  
  def new
    @test = Test.new
    @categories = Category.all
  end
  
  def edit
    @test = Test.find(params[:id])
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
  
  def next_question(test_id, id)
    test = Test.find(test_id)
    words = test.words
    item = words.where("id > ?", id).first
    item ||= words.first
    return item.id
  end
  
  def prev_question(test_id, id)
    test = Test.find(test_id)
    words = test.words
    item = words.where("id < ?", id).last
    item ||= words.last
    return item.id
  end
  
  
  def sort_column
    params[:sort] || "name"
  end
  def sort_direction
    params[:direction] || "asc"
  end
end
