class PerfumesController < ApplicationController
    def new
        @perfume = Perfume.new
    end

    def show
        @perfume = Perfume.find_by(id: params[:id])
        calculate_diagnosis
    end

    def create
        @perfume = Perfume.new(perfume_params)
        if @perfume.save
        flash[:notice] = "診断が完了しました"
        redirect_to perfume_path(@perfume.id)
        else
        render :new
        end
    end

    private

    def perfume_params
        params.require(:perfume).permit({ question1: [] }, { question2: [] }, { question3: [] })
    end

    def calculate_diagnosis
        counts = { 視覚型: 0, 聴覚型: 0, 運動感覚型: 0 }

        counts[:視覚型] += @perfume.question1&.count || 0
        counts[:聴覚型] += @perfume.question2&.count || 0
        counts[:運動感覚型] += @perfume.question3&.count || 0

        @dominant_type = counts.max_by { |_, v| v }[0]
    end
end
