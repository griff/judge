class Module
  def alias_method_chain(target, feature)
    # Strip out punctuation on predicates or bang methods since
    # e.g. target?_without_feature is not a valid method name.
    aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1
    yield(aliased_target, punctuation) if block_given?
    alias_method "#{aliased_target}_without_#{feature}#{punctuation}", target
    alias_method target, "#{aliased_target}_with_#{feature}#{punctuation}"
  end
end

module Judge
  autoload :AlreadyFactoryError, 'judge/extensions/factories'
  autoload :AlreadyPartisanError, 'judge/extensions/partisans'
  
  Extensions = [].to_set
  def self.load_extension(name)
    if !Extensions.include?(name.to_sym)
      require 'judge/extensions/'+name.to_s
    end
  end
end
