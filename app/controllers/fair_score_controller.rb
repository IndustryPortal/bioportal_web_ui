class FairScoreController < ApplicationController

  helper FairScoreHelper
  include FairScoreHelper
  def details_html
    begin
      get_fair
      render partial: 'details'
    rescue => e
      render plain: e.message
    end
  end

  def details_json
    begin
      get_fair
      render json: @fair_scores_data
    rescue => e
      render plain: e.message
    end
  end

  private

  def get_fair
    not_found if params[:ontologies].nil? || params[:ontologies].empty?
    @ontologies = params[:ontologies]
    begin
      if @ontologies.include? ','
        @fair_scores_data = create_fair_scores_data(get_fair_combined_score(@ontologies), @ontologies.split(',').length)
      elsif @ontologies.eql? 'all'
        tmp = get_fairness_json(@ontologies)
        @fair_scores_data = create_fair_scores_data(tmp['combinedScores'], tmp['ontologies'].keys.length)
      else
        @rest_uri = "#{REST_URI}/ontologies/#{@ontologies}/latest_submission?display=all"
        @fair_scores_data = create_fair_scores_data(get_fair_score(@ontologies).values.first, 1)
      end
    rescue NameError
      raise StandardError, 'Error: load failed'
    end
  end
end