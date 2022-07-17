# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    @selected = []
    @all_ratings = Movie.all_ratings
    @all_ratings.each { |r| @selected.push(r) if params["ratings"] && params["ratings"][r.to_s] }
    @selected = @selected.size == 0 ? @all_ratings : @selected
    
    @class_variable = "hilite"
    @movies = Movie.all.select {|m| @selected.include?(m.rating) }
    
    sort_key = params[:sort_by]
    if !sort_key.nil?
    @movies = @movies.order(sort_key)
    end
    
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end