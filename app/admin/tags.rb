# frozen_string_literal: true

ActiveAdmin.register ActsAsTaggableOn::Tag do
  menu label: 'Tags'

  permit_params :name, :slug, :data, :notable, :stack

  batch_action :notable do
    resource_class.where(id: params[:collection_selection].uniq).update_all(data: { notable: true }.to_json)
    redirect_to collection_path, notice: 'Notabled.'
  end

  filter :taggings_context_eq, as: :select, collection: lambda {
                                                          ActsAsTaggableOn::Tagging.distinct(:context).pluck(:context)
                                                        }
  filter :name
  filter :slug

  controller do
    def find_resource
      resource_class.friendly.find(params[:id])
    end

    def scoped_collection
      super.distinct(:id)
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :slug
      f.input :stack
      f.input :notable
    end
    f.actions
  end
end
