namespace :update do
  task :'polygons' do

    Survey.all.each do |survey|
      survey_update_params = {
        settlement_string_id: survey.string_id,
        survey: {
          poligon: survey.polygon,
          families_count: survey.families_count,
          settlement_type: survey.settlement_type,
          data: {},
          indicator:{ id: survey.indicator.try(:id), data:{} }
        }
      }
      saver = Services::SurveySaver.update(survey, survey_update_params)

      if saver.valid? && saver.survey.valid?
        print '.'
      else
        survey.visible = false
        survey.save if survey.valid?
        puts "\nError - No se pudo actualizar el poligono de la encuesta con ID: #{survey.id} del asentamiento #{survey.string_id} del año #{survey.year}"
      end
    end

  end
end
