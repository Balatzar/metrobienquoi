class SearchesController < ApplicationController
  def index
    @searches = Search.all
  end

  def show
    @search = Search.find(params[:id])
  end

  def new
    @search = Search.new
  end

  def create
    @search = Search.new(search_params)

    if @search.save
      redirect_to @search, notice: 'Search was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def search_params
    params.require(:search).permit(station_ids: [])
  end
end
