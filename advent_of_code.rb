# frozen_string_literal: true

require "optparse"
require "pathname"

parser = OptionParser.new do |opts|
  opts.on("-yYEAR", "--year YEAR", Integer)
  opts.on("-dDAY", "--day DAY", Integer)
end

year, day = {}.tap { |h| parser.parse!(into: h) }.values_at(:year, :day)
pathname = Pathname.new("#{year}/#{day}/#{day}.rb")

raise ArgumentError, "file does not exist" unless pathname.exist?

Dir.chdir(pathname.dirname) do
  load(pathname.basename)
end
