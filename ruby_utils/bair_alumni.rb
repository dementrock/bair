require "google/api_client"
require "google_drive"
require "pry"
require "active_support/all"

def get_sorted_rows
  session = GoogleDrive.saved_session(nil, nil, ENV["BAIR_GOOGLE_DRIVE_CLIENT_ID"], ENV["BAIR_GOOGLE_DRIVE_CLIENT_SECRET"])

  bair_alumni_file = session.file_by_title("BAIR Alumni")

  advisor_name_dict = {
    "Abbeel" => "Pieter Abbeel",
    "Jordan" => "Michael I. Jordan",
    "Russell" => "Stuart Russell",
    "Goldberg" => "Ken Goldberg",
    "Malik" => "Jitendra Malik",
    "Darrell" => "Trevor Darrell",
    "Dragan" => "Anca Dragan",
    "Efros" => "Alyosha Efros",
    "Klein" => "Dan Klein",
  }

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

  all_rows
    .group_by{|x| [x[:year], x[:first_name], x[:last_name]]}
    .to_a.map{|x| x[1][0].merge(advisor: x[1].map{|y| y[:advisor]}.join(", "))} # join advisors
    .reject{|x| x[:year].blank?} # only show the ones with year filled in
    .group_by{|x| x[:year]}

end

if __FILE__ == $0
  get_sorted_rows
end
