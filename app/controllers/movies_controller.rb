class MoviesController < ApplicationController

  def show
	id = params[:id] # retrieve movie ID from URI route
	if (id =~ /^[-+]?[0-9]+$/) then
		@movie = Movie.find(id) # look up movie by unique ID
	else 
	    session[:sort] = params[:id]
		redirect_to movies_path
	end
  end
  
  def index
	if session[:sort] == "title_header" then
		@movies = Movie.order("title").all
	elsif session[:sort] == "release_date_header" then
		@movies = Movie.order("release_date").all
	else 
		@movies = Movie.all
	end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
