class CurrentPasswordValidator < ActiveModel::EachValidator
  def initialize(options)
    options[:column] ||= []
    
    super
  end
  
  def validate_each(record, attribute, value)
    if (record.changed & options[:fields].map(&:to_s)).any?
      if record.current_password.blank?
        record.errors.add(attribute, :blank) 
      elsif BCrypt::Password.new(record.password_digest) != record.current_password
        record.errors.add(attribute, :current_password_no_mathch)
      end
    end
  end

  def client_side_hash(record, attribute)
    hash = {:message => record.errors.generate_message(attribute, :blank)}
    hash[:fields] = {}
    options[:fields].each do |field|
      hash[:fields][field] = ((field !~ /password/) ? record.read_attribute(field) : "")
    end
    hash
  end
end
