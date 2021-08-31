# frozen_string_literal: true

# attr_json was being weird and didn't want to mess with it.
module JsonAttribute
  module ClassMethods
    def json_attribute(name, type, column_name, validates: {})
      attribute name, type

      validates name, **validates if validates.any?

      define_method name do
        read_attribute(column_name)[name.to_s]
      end

      define_method :"#{name}=" do |val|
        super(val)
        read_attribute(column_name)[name.to_s] = read_attribute(name)
      end
    end
  end
end
