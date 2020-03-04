class GamesController < ApplicationController

  before_action :set_game, only: [:edit, :show, :destroy]

  def index
    if params[:address].blank?
        @games = Game.all
    else
        @games = Game.search(params[:address], fields: [:address])
    end
    @markers = @games.geocoded.map do |game|
      {
        lat: game.latitude,
        lng: game.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { game: game }),
        image_url: helpers.asset_url('football-marker')
      }
  end

  def show
    @booking = Booking.new
  end

  def new
    @team = Team.find(params[:team_id])
    @game = Game.new
  end

  def edit
  end

  def create
    @team = Team.find(params[:team_id])
    @game = Game.new(game_params)
    @game.team = @team
    if @game.save
      redirect_to game_path(@game)
    else
      render :new
    end
  end

  def destroy
    @game.destroy
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:address, :date, :time, :price, :format, :sport, :available_spaces)
  end

end
