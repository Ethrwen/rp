class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
		@titleCSS = ""
		@all_ratings = Movie.all_ratings
		
		if session[:saved] == 1 and !params.key?("title_sorted") and !params.key?("release_sorted") and !params.key?("ratings")
			params[:title_sorted] = session[:sort_title]
			params[:release_sorted] = session[:sort_release]
			params[:ratings] = session[:filter]
			redirect_to(movies_path(params))
		end
		
		if params[:ratings].nil?
			@ratings_to_show = []
			@movies = Movie.all
			@ratings_mem = {}
		else
			@ratings_to_show = params[:ratings].keys
			@movies = Movie.with_ratings(@ratings_to_show)
			@ratings_mem = params[:ratings]
		end
		
		if params[:title_sorted] == "1"
			@movies = @movies.order("title")
			@titleCSS = "hilite bg-warning"
		elsif params[:release_sorted] == "1"
			@movies = @movies.order("release_date")
			@releaseCSS = "hilite bg-warning"
		end
		
		session[:saved] = 1
		session[:sort_title] = params[:title_sorted]
		p_title = params[:title_sorted]
		session[:sort_release] = params[:release_sorted]
		session[:filter] = params[:ratings]
# 		debugger
		
		
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
