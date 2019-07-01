# Its a self realization class Struct
class Factory
  def self.new(*fields, &block)
    class_name, *other_fields = fields

    if class_name.instance_of?(String) && class_name.match?(/\A[A-Z]/)
      return const_set(class_name, new_class(*other_fields, &block))
    end

    new_class *fields, &block
  end

  def self.new_class(*properties, &block)
    Class.new do
      attr_accessor(*properties)

      define_method :initialize do |*args|
        raise ArgumentError unless args.length == properties.length

        properties.each_with_index do |property, index|
          instance_variable_set "@#{property}", args[index]
        end
      end

      define_method :== do |other|
        self.class == other.class && self.values == other.values
      end

      alias_method :eql?, :==

      define_method :members do
        properties
      end

      define_method :size do
        instance_variables.size
      end

      alias_method :length, :size

      define_method :[] do |property|
        if property.instance_of? Integer
          return instance_variable_get instance_variables[property]
        end

        instance_variable_get "@#{property}"
      end

      define_method :[]= do |property, value|
        instance_variable_set "@#{property}", value
      end

      def each(&block)
        values.each(&block)
      end

      def each_pair(&block)
        members.zip(values).each(&block)
      end

      def to_a
        instance_variables.map do |prop|
          instance_variable_get prop
        end
      end

      def select(&block)
        to_a.select(&block)
      end

      def values_at(*props)
        values.select { |prop| props.include?(values.index(prop)) }
      end

      def dig(*args)
        args.inject(self) { |memo, obj| memo[obj] unless memo.nil? }
      end

      alias_method :values, :to_a

      class_eval(&block) if block_given?
    end
  end
end
