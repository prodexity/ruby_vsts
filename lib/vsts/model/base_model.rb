# VSTS namespace
module VSTS
  # Ancestor class for all VSTS models
  class BaseModel
    # Convert camel-case to underscore-case, ie. helloWorld to hello_world
    def underscore(word)
      word.to_s.gsub(/::/, '/')
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr("-", "_")
          .downcase
    end
  end
end
