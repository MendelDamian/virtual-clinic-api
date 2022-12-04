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
    default_pagination_params = { page: DEFAULT_PAGE, per_page: DEFAULT_PER_PAGE }
    params.reverse_merge!(default_pagination_params)
    @page = params[:page].to_i
    @per_page = params[:per_page].to_i

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
