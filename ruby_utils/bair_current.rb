require "google/api_client"
require "google_drive"
require "pry"
require "active_support/all"

def get_sorted_rows
  session = GoogleDrive.saved_session(nil, nil, ENV["BAIR_GOOGLE_DRIVE_CLIENT_ID"], ENV["BAIR_GOOGLE_DRIVE_CLIENT_SECRET"])

  bair_current_file = session.file_by_title("BAIR current")

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
    "Position" => :position,
    "research interests" => :research_interests,
    "URL to head-shot" => :image_url,
    "Image Preview" => :_preview,
    "URL of webpage" => :webpage,
    "email" => :email,
  }

  bair_current_file.worksheets.each do |worksheet|
    STDERR.puts "Processing #{worksheet.title}"
    rows = worksheet.rows
    dict_keys = rows[0]
    replaced_keys = dict_keys.map{|x| dict_keys_sub[x]}
    dict_rows = rows[1..-1].map{|row| Hash[replaced_keys.zip(row)].merge(advisor: advisor_name_dict[worksheet.title]) }
    all_rows += dict_rows  
  end

  all_rows
    .reject{|x| x[:image_url].blank?} # only show the ones with profile image filled in
    .sort_by{|x| x[:last_name]}

end

if __FILE__ == $0
  get_sorted_rows
end
