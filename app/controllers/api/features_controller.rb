class Api::FeaturesController < ApplicationController
  def index
    FeatureService.update_data_usgs

    # Obtener los parámetros de la petición
    page = params.fetch(:page, 1).to_i
    page = [page, 1].max
    elements_per_page = params.fetch(:elements_per_page, 10).to_i
    elements_per_page = [elements_per_page, 1000].min
    elements_per_page = [elements_per_page, 10].max
    mag_types = params.fetch(:mag_type, "").split(",")

    # Filtrado de data por magType
    seismic_data = Feature.all
    seismic_data = seismic_data.where(Feat_MagType: mag_types) if mag_types.any?
    seismic_data_length = seismic_data.length
    seismic_data = seismic_data.order(id: :desc)
    

    # Paginación de resultados
    seismic_data = seismic_data.paginate(page: page, per_page: elements_per_page)
    response = FeatureService.format_seismic_data(seismic_data, page, elements_per_page, seismic_data_length)
    
    render json: response, status: 200
  end

  def show_comments
    feature = Feature.find_by(id: params[:id].to_i)
    comments = Comment.where(feature_id: params[:id].to_i)

    if feature
      feature = FeatureService.format_seismic_data([feature], 10, 10 ,10)
      feature = feature[:data][0]
      render json: {feature_data: feature, comments: comments}, status: 200
    else
      render json: {error: "Feature no existente..."}, status: 404
    end
  end

  def create_comment
    comment = Comment.new(
      feature_id: params[:id],
      Comm_Body: params[:body],
    )

    if comment.save
      render json: comment, status: :created
    else
      render json: { error: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

end