require "cxml/extrinsic"

module Extrinsicable
  def self.included(base)
    base.accessible_nodes [:extrinsics]
  end

  def initialize_extrinsic(value)
    value = [value] unless value.is_a?(Array)
    @extrinsics = value.map do |item|
      CXML::Extrinsic.new(item)
    end
  end

  def initialize_extrinsics(value)
    value = [value] unless value.is_a?(Array)
    @extrinsics = value.map do |item|
      CXML::Extrinsic.new(item)
    end
  end

  # Finds matching extrinisic name and sets new value, will make new extrinsic based on name/value otherwise
  def set_extrinsic(name, value)
    extrinsic = get_extrinsic name
    if extrinsic
      extrinsic.content = value
      return
    end

    new_extrinsic = CXML::Extrinsic.new name: name, content: value
    @extrinsics.push(new_extrinsic)
  end

  # Finds matching extrinsic
  def get_extrinsic(name)
    @extrinsics ||= []
    @extrinsics.each do |ex|
      if ex.name == name
        return ex
      end
    end
    nil
  end
end
