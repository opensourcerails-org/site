# frozen_string_literal: true

require 'json_attribute'

module ActsAsTaggableOn
  class Tag
    # attr_json was being weird, didn't want to mess with it. this will do for now.
    extend ::JsonAttribute::ClassMethods
    json_attribute :notable, :boolean, :data
    json_attribute :stack, :boolean, :data

    extend FriendlyId
    friendly_id :name, use: :slugged

    after_commit do
      contexts = taggings.distinct(:context).pluck(:context)
      contexts.each do |context|
        if context.end_with?('_stack')
          TagCache.stacks(true)
        elsif TagCache.respond_to?(context)
          TagCache.public_send(context, true)
        end
      end
    end

    def self.with_context(context)
      where(id: ActsAsTaggableOn::Tag.select(:id).distinct(:id).joins(:taggings).where(taggings: { context: context })).where('visible_taggings_count > 0')
    end
  end
end

module ActsAsTaggableOn
  class Tagging
    after_commit do
      unless destroyed?
        tag.update_column(:visible_taggings_count,
                          Project.visible.where(id: Project.visible.where(id: tag.taggings.where(taggable_type: 'Project').pluck(:taggable_id))).count)
      end
    end
  end
end

# using find_similar_* breaks with json/jsonb columns
module ActsAsTaggableOn::Taggable::Core
  def grouped_column_names_for(object)
    object.column_names.select { |column| object.columns_hash[column].type != :json && object.columns_hash[column].type != :jsonb } .map { |column| "#{object.table_name}.#{column}" }.join(', ')
  end
end
