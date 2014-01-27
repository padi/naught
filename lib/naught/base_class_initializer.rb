module Naught
  class BaseClassInitializer
    attr_reader :builder, :base_class

    def initialize(builder)
      @builder = builder
      @base_class = builder.base_class
    end

    def execute(generation_mod, customization_mod)
      builder = @builder
      Class.new(base_class) do
        const_set :GeneratedMethods, generation_mod
        const_set :Customizations, customization_mod
        const_set :NULL_EQUIVS, builder.null_equivalents
        include Conversions
        remove_const :NULL_EQUIVS
        Conversions.instance_methods.each do |instance_method|
          undef_method(instance_method)
        end
        const_set :Conversions, Conversions

        include NullObjectTag
        include generation_mod
        include customization_mod
      end
    end
  end
end
