class TagStringValidator < ActiveModel::EachValidator
  def initialize(options)
    options[:limit] ||= 5

    super
  end

  def validate_each(record, attribute, value)
    if value.split(/[,\s]+/).uniq.count > options[:limit]
      record.errors.add(attribute, :tag_string, options)
    end
  end
end
