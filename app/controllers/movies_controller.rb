class MoviesController < ApplicationController

  def get_all_ratings
	return Movie.select("DISTINCT rating").map(&:rating)
  end
  
  def show
	id = params[:id] # retrieve movie ID from URI route
	@movie = Movie.find(id) # look up movie by unique ID	
  end
  
  def index
	puts "1:" +  params.inspect
	@all_ratings = get_all_ratings()
	updated = false
	
	if (params[:ratings] == nil || params[:ratings].length == 0) then
		if (session[:ratings] != nil && session[:ratings].length > 0) then
			params[:ratings] = session[:ratings];
			updated = true
		else 
			params[:ratings] = Hash.new();
			@all_ratings.each do |rating| 
				params[:ratings][rating] = 1
			end
		end
	end	
	
	if (params[:ratings].is_a?(Hash)) then
		ratings = params[:ratings].keys
	else
		ratings = params[:ratings]
	end
	
	if (params[:sort] == nil && session[:sort] != nil) then 
		params[:sort] = session[:sort]
		updated = true
	end
	
	if (updated) then
		session[:sort] = params[:sort]
		session[:ratings] = params[:ratings]
		flash.keep()
		puts "2:" + params.inspect
		redirect_to params.merge(:action => "index")
	end
	
	if params[:sort] == "title" then
		@movies = Movie.where(:rating => ratings).order("title")
	elsif params[:sort] == "release_date" then
		@movies = Movie.where(:rating => ratings).order("release_date")
	else 
		@movies = Movie.where(:rating => ratings)
	end
	
	session[:sort] = params[:sort];
	session[:ratings] = params[:ratings];
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
