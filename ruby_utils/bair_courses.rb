require "google_drive"
require "pry"
require "active_support/all"

def get_course_list
  session = GoogleDrive.saved_session("/root/ruby_google_drive.token", nil, ENV["BAIR_GOOGLE_DRIVE_CLIENT_ID"], ENV["BAIR_GOOGLE_DRIVE_CLIENT_SECRET"])

  dict_keys_sub = {
    "Course Number" => :number,
    "Name" => :name,
    "URL" => :url,
    "Brief Description" => :description,
  }

  bair_current_file = session.file_by_title("BAIR courses")
  ug_sheet = bair_current_file.worksheets[0]
  grad_sheet = bair_current_file.worksheets[1]
  fail unless ug_sheet.title == "undergrad"
  fail unless grad_sheet.title == "grad"
  rows = [ug_sheet, grad_sheet].map do |worksheet|
    rows = worksheet.rows
    dict_keys = rows[0]
    replaced_keys = dict_keys.map{|x| dict_keys_sub[x]}
    dict_rows = rows[1..-1].map{|row| Hash[replaced_keys.zip(row)].merge(type: worksheet.title)}
    dict_rows
  end.flatten
  rows = rows.reject{|x| x[:number].blank?}
  rows
end


if __FILE__ == $0
  get_course_list
end


#courses = [
#  {
#    number: "CS 188",
#    url: "http://www.eecs.berkeley.edu/Courses/Data/215.html",
#    name: "Artificial Intelligence",
#  },
#  {
#    number: "CS 189",
#    url: "http://www.cs.berkeley.edu/~jrs/189/",
#    name: "Machine Learning",
#  },
#  {
#    number: "EE 227B",
#    url: "http://www.eecs.berkeley.edu/~elghaoui/Teaching/EE227BT/",
#    name: "Convex Optimization",
#  },
#  {
#    number: "EE 227C",
#    url: "http://www.eecs.berkeley.edu/~brecht/eecs227c.html",
#    name: "Convex Optimization and Approximation: Optimization for Modern Data Analysis",
#  },
#  {
#    number: "CS 280",
#    url: "https://inst.eecs.berkeley.edu/~cs280/sp16/",
#    name: "Computer Vision",
#  },
#  {
#    number: "CS 281A",
#    url: "javascript:void(0)",
#    name: "Statistical Learning Theory",
#  },
#  {
#    number: "CS 281B",
#    url: "https://bcourses.berkeley.edu/courses/1409209",
#    name: "Statistical Learning Theory",
#  },
#  {
#    number: "CS 287",
#    url: "http://www.cs.berkeley.edu/~pabbeel/cs287-fa15/",
#    name: "Advanced Robotics",
#  },
#  {
#    number: "CS 288",
#    url: "http://www.cs.berkeley.edu/~klein/cs288/fa14/",
#    name: "Statistical Natural Language Processing",
#  },
#]
