# frozen_string_literal: true

class File
  def self.read(name, ...)
    demo? ? super("demo.txt", ...) : super(name, ...)
  end

  def self.foreach(name, ...)
    demo? ? super("demo.txt", ...) : super(name, ...)
  end
end

def demo?
  $options[:demo]
end
