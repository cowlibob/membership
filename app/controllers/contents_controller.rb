class ContentsController < ApplicationController
  
  def edit
  end

  def update
    @content = Content.find(:conditions => {:tag => params[id]})
    @content.update_attributes(params[:content])
  end

end
