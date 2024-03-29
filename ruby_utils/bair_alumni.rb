require "google_drive"
require "pry"
require "active_support/all"

def get_sorted_rows(faculty_list)

  session = GoogleDrive.saved_session("/root/ruby_google_drive.token", nil, ENV["BAIR_GOOGLE_DRIVE_CLIENT_ID"], ENV["BAIR_GOOGLE_DRIVE_CLIENT_SECRET"])

  bair_alumni_file = session.file_by_title("BAIR Alumni")

  advisor_name_dict = Hash[faculty_list.map{|x| [x[:last_name], "#{x[:first_name]} #{x[:last_name]}"]}]
  advisor_url_dict = Hash[faculty_list.map{|x| ["#{x[:first_name]} #{x[:last_name]}", x[:url]]}]

  advisor_name_dict["Wilensky"] = "Robert Wilensky"
  advisor_url_dict["Wilensky"] = "https://www2.eecs.berkeley.edu/Faculty/Homepages/wilensky.html/"

  all_rows = []

  dict_keys_sub = {
    "First Name" => :first_name,
    "Last Name" => :last_name,
    "Current Position" => :current_position,
    "Position at \"BAIR\"" => :bair_position,
    "year of \"graduation\"" => :year,
    "current webpage" => :webpage,
    "email" => :email,
    "Advisor" => :advisor
  }

  bair_alumni_file.worksheets.each do |worksheet|
    STDERR.puts "Processing #{worksheet.title}"
    rows = worksheet.rows
    dict_keys = rows[0]
    replaced_keys = dict_keys.map{|x| dict_keys_sub[x]}
    dict_rows = rows[1..-1].map{|row| Hash[replaced_keys.zip(row)].merge(advisor: advisor_name_dict[worksheet.title]) }
    all_rows += dict_rows  
  end

  all_rows = all_rows.reject{|x| x[:first_name].blank?}

  def normalize_position(s)
    s.downcase.gsub(/[^\w]/,"")
  end

  cleanup_position = {
    "phdstudent" => :phd,
    "phd" => :phd,
    "ms" => :master,
    "researchscientist" => :research_scientist,
    "postdoc" => :postdoc,
    "undergraduate" => :undergraduate,
    "masterstudent" => :master,
    "mastersstudent" => :master,
    "master" => :master,
    "undergradsummerresearch" => :undergraduate,
    "postdocvisiting" => :postdoc,
  }

  all_rows = all_rows.map do |x|
    normalized = normalize_position(x[:bair_position])
    if not cleanup_position.include?(normalized) and not x[:bair_position].blank?
      STDERR.puts "Invalid position!"
      STDERR.puts x
    end
    cleanup = cleanup_position[normalized]
    x.merge(raw_bair_position: cleanup)
  end

  all_rows
    .group_by{|x| [x[:first_name].strip, x[:last_name].strip]}
    .to_a.map{|x| x[1][0].merge(advisor: x[1].map{|y|
      %Q{<a href="#{advisor_url_dict[y[:advisor]]}">#{y[:advisor]}</a>}
    }.join(", "))} # join advisors
    .map{|x| x.merge(position: cleanup_position[x[:position]])}

end

if __FILE__ == $0
  require_relative './bair_faculty.rb'
  faculty_list = get_faculty_list
  sorted_rows = get_sorted_rows(faculty_list)
end
