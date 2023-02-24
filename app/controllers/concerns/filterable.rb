# frozen_string_literal: true

#  A concern to encapsulate filtering methods for controllers
module Filterable
  #  As a ruby convention, "resource" is used to denote a class name that is an argument,
  #  meaning that this concern can work for any class that has the corresponding services.
  def filter!(resource)
    store_filters(resource)
    apply_filters(resource)
  end

  private

  def filter_key(resource)
    "#{resource.to_s.underscore}_filters:#{current_user.id}"
  end

  def store_filters(resource)
    key = filter_key(resource)
    stored_filters = Kredis.hash(key)
    stored_filters.update(**filter_params_for(resource))
  end

  def filter_params_for(resource)
    params.permit(resource::FILTER_PARAMS)
  end

  def apply_filters(resource)
    key = filter_key(resource)
    resource.filter(Kredis.hash(key))
  end
end
