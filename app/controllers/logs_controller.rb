class LogsController < ApplicationController

    # POST /logs/analyze
    def analyze
        file = params[:file]
        begin
          @reports = LogAnalyzerService.analyze(file.tempfile)
          render json: @reports
        rescue StandardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
    end
end
  