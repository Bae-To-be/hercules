# frozen_string_literal: true

class ArticlesController < ApplicationController
  layout false, only: [:show]

  def show
    @article = Article.find(params[:id])
  end
end
