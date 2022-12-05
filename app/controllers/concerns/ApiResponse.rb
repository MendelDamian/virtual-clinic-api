module ApiResponse
  extend ActiveSupport::Concern

  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10

  def set_collection
    raise NotImplementedError
  end

  def filtering_params
    raise NotImplementedError
  end

  def json_response
    @page = params[:page].present? ? params[:page].to_i : DEFAULT_PAGE
    @per_page = params[:per_page].present? ? params[:per_page].to_i : DEFAULT_PER_PAGE

    return render json: { error: 'Invalid page number' }, status: :bad_request unless validate_pagination_params?

    @collection = set_collection
    @collection = @collection.filter(filtering_params)
    @total = @collection.count
    @collection = @collection.offset((@page - 1) * @per_page).limit(@per_page)
    @collection = @collection.limit(@per_page)

    render json: {
      data: @collection,
      total: @total,
      page: @page,
      per_page: @per_page
    }, status: :ok
  end

  private

  def validate_pagination_params?
    @page > 0 && @per_page > 0
  end
end
