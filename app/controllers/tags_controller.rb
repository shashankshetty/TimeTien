class TagsController < ApplicationController
  def index
    @tags = current_user.tags
    respond_to do |format|
      format.html
    end
  end

  def new
    @tag = Tag.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def create
    @tag = Tag.new
    populate_tag
    @tag.user = current_user
    result = @tag.save
    set_message_for_render result, "created"
    respond_to do |format|
      if result
        format.html { render action: :edit }
      else
        format.html { render action: :new }
      end
    end
  end

  def update
    @tag = Tag.find(params[:id])
    populate_tag
    set_message_for_render @tag.save, "updated"
    respond_to do |format|
      format.html { render action: :edit }
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    set_message_for_redirect @tag.destroy, "deleted"
    respond_to do |format|
      format.html { redirect_to tags_url }
    end
  end

  private

  def set_message_for_redirect(result, action)
    if result
      flash[:success] = "Tag was successfully #{action}."
    else
      flash[:error] = @tag.errors.full_messages
    end
  end

  def set_message_for_render(result, action)
    if result
      flash.now[:success] = "Tag was successfully #{action}."
    else
      flash.now[:error] = @tag.errors.full_messages
    end
  end

  def populate_tag
    @tag.update_attributes(params[:tag])
    hours = params[:hours].to_i
    minutes = params[:minutes].to_i
    @tag.time_allocated = hours * 60 + minutes
    @tag.time_allocated = nil if @tag.time_allocated == 0
  end
end