# frozen_string_literal: true

class Array
  # File activesupport/lib/active_support/core_ext/array/grouping.rb, line 93
  def split(value = nil, &block)
    arr = dup
    result = []
    if block_given?
      while (idx = arr.index(&block))
        result << arr.shift(idx)
        arr.shift
      end
    else
      while (idx = arr.index(value))
        result << arr.shift(idx)
        arr.shift
      end
    end
    result << arr
  end
end
