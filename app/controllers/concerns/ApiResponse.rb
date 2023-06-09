module ApiResponse
  extend ActiveSupport::Concern

  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10
  PAGINATION_ERROR = { "pagination": ["has invalid values"] }

  def set_collection
    raise NotImplementedError
  end

  def filtering_params
    raise NotImplementedError
  end

  def serializer
    collection_class_name = @collection.model_name.name
    "#{collection_class_name}Serializer".constantize
  rescue
    nil
  end

  def json_response
    set_pagination_params
    return render json: { errors: PAGINATION_ERROR }, status: :unprocessable_entity unless pagination_params_valid?

    set_collection
    @collection = @collection.filter_using filtering_params if filtering_params.present?
    @total = @collection.count
    paginate

    render json: {
      data: serialize_data,
      total: @total,
      page: @page,
      per_page: @per_page
    }, status: :ok
  end

  private

  def pagination_params_valid?
    @page > 0 && @per_page > 0
  end

  def set_pagination_params
    @page = params[:page].present? ? params[:page].to_i : DEFAULT_PAGE
    @per_page = params[:per_page].present? ? params[:per_page].to_i : DEFAULT_PER_PAGE
  end

  def paginate
    @collection = @collection.offset((@page - 1) * @per_page).limit(@per_page)
  end

  def serialize_data
    ActiveModelSerializers::SerializableResource.new(@collection, each_serializer: serializer)
  end
end
