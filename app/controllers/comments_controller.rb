class CommentsController < ApplicationController
before_action :require_user
    def create
        @recipe = Recipe.find(params[:recipe_id])
        @comment = @recipe.comments.build(comments_params)
        @comment.chef = current_chef
        if @comment.save
            ActionCable.server.broadcast "comments", render(partial: 'comments/comment', object: @comment)
            # flash[:success] = "Comment was created successfully"
            # redirect_to recipe_path(@recipe)
        else
            flash[:danger] = "Comment was not created"
            redirect_back fallback_location: @recipe
        end
    end

    private

    def comments_params
        params.require(:comment).permit(:description)
    end
end