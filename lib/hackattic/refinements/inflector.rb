module Hackattic
  module Refinements
    # Stolen from Rails. Hueheuehue.
    module Inflector
      refine(String) do
        def underscore
          gsub(/::/, '/')
            .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
            .gsub(/([a-z\d])([A-Z])/,'\1_\2')
            .tr('-', '_')
            .downcase
        end

        def camelize
          split('_').collect(&:capitalize).join
        end
      end
    end
  end
end
