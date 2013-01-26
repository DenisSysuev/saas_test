class MoviesController < ApplicationController

  def get_all_ratings
	return Movie.select("DISTINCT rating").map(&:rating)
  end
  
  def show
	id = params[:id] # retrieve movie ID from URI route
	@movie = Movie.find(id) # look up movie by unique ID	
  end
  
  def index
	@all_ratings = get_all_ratings()
	
	ratings = @all_ratings
	if (params["ratings"] != nil) then
		ratings = params["ratings"].keys 
	end
	
	if params[:sort] == "title" then
		@movies = Movie.where(:rating => ratings).order("title")
	elsif params[:sort] == "release_date" then
		@movies = Movie.where(:rating => ratings).order("release_date")
	else 
		@movies = Movie.where(:rating => ratings)
	end
	
	if (params["ratings"] == nil) then
		params["ratings"] = Hash.new();
		@all_ratings.each do |rating|
			params["ratings"][rating] = 1;
		end
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
