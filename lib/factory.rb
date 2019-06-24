class Factory
  def self.new(class_name, *attributes)
    const_set(class_name, new_class(attributes))
  end

  def self.new_class(*props)
    Class.new do
      # attr_accessor(props)

      define_method :initialize do |*args|
        # unless args.size == props.size
        #   raise ArgumentError, 'Wrong number of arguments'
        # end
        print args, *props

        # props.each do |attribute, index|
        #   instance_variable_set("@#{attribute}", args[index])
        # end
      end
    end
  end
end

Factory.new('Customer', :name, :address)
Factory::Customer.new(123, 1203)
