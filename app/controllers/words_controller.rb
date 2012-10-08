class WordsController < ApplicationController
  def create
    @test = Test.find(params[:test_id])
    @word = @test.words.create(params[:word]) #creates and saves the comment, and will automatically link the comment so that it belongs to that particular post.
    redirect_to test_path(@test)
  end
  def destroy
    @test = Test.find(params[:test_id])
    @word = @test.words.find(params[:id])
    @word.destroy
    redirect_to test_path(@test)
  end
  
  def edit
    @test = Test.find(params[:test_id])
    @word = @test.words.find(params[:id])
  end
  
  def update
    @test = Test.find(params[:test_id])
    @word = @test.words.find(params[:id])
    
    respond_to do |format|
      if @word.update_attributes(params[:word])
        format.html { redirect_to @test, notice: 'Word was succesfully updated.'}
      else
        format.html { render action: 'edit' }
      end
    end
  end
end
