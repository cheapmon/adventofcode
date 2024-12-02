# frozen_string_literal: true

def report_safe?(report)
  difference_valid = report.each_cons(2).all? { |a, b| (a - b).abs.between?(1, 3) }
  strictly_increasing = report.each_cons(2).all? { |a, b| b > a }
  strictly_decreasing = report.each_cons(2).all? { |a, b| a > b }

  difference_valid && (strictly_increasing || strictly_decreasing)
end

n_safe_reports = 0
n_almost_safe_reports = 0

File.foreach("2.txt", chomp: true) do |line|
  report = line.split(" ").map(&:to_i)

  if report_safe?(report)
    n_safe_reports += 1
    n_almost_safe_reports += 1
    next
  end

  report.each_index do |i|
    other_report = report.dup
    other_report.delete_at(i)

    if report_safe?(other_report)
      n_almost_safe_reports += 1
      break
    end
  end
end

puts n_safe_reports
puts n_almost_safe_reports
