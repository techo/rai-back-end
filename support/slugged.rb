module Slugged

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def slugged(string)
      string.to_slug.normalize.to_s
    end
  end

  # https://github.com/jeremyevans/sequel/blob/master/doc/model_hooks.rdoc#simple-module
  def before_save
    if respond_to?(:name) && (new? || modified?(:name))
      self.slug = slugged(name)
    end

    super
  end

  private

  def slugged(string)
    self.class.slugged(string)
  end

end
