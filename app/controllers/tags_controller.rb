class TagsController < ApplicationController
  def index
    @tags = current_user.tags
  end

  def new
    @tag = Tag.new
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
        format.mobile { render action: :edit }
      else
        format.html { render action: :new }
        format.mobile { render action: :new }
      end
    end
  end

  def update
    @tag = Tag.find(params[:id])
    populate_tag
    set_message_for_render @tag.save, "updated"
    respond_to do |format|
      format.html { render action: :edit }
      format.mobile { render action: :edit }
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    if @tag.tasks.where("user_id != ?", current_user.id).count > 0
      flash[:alert] = "Cannot delete the tag. Other users in the project using tha tag."
      respond_to do |format|
        format.html { render action: :edit }
        format.mobile { render action: :edit }
      end
    else
      result = @tag.destroy
      if result
        flash[:success] = "Tag was successfully deleted."
        respond_to do |format|
          format.html { redirect_to tags_url }
          format.mobile { redirect_to tags_url }
        end
      else
        flash[:alert] = @tag.errors.full_messages
        respond_to do |format|
          format.html { render action: :edit }
          format.mobile { render action: :edit }
        end
      end
    end
  end

  private

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
    if params[:complete_within] == "true" || params[:complete_within] == "on"
      @tag.complete_within = true
    else
      @tag.complete_within = false
    end
  end
end