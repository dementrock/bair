require "google/api_client"
require "google_drive"
require "pry"
require "active_support/all"
require "firebase"
require "cloudinary"

def get_sorted_rows(faculty_list)
  session = GoogleDrive.saved_session(nil, nil, ENV["BAIR_GOOGLE_DRIVE_CLIENT_ID"], ENV["BAIR_GOOGLE_DRIVE_CLIENT_SECRET"])

  bair_current_file = session.file_by_title("BAIR current students/post-docs")

  advisor_name_dict = Hash[faculty_list.map{|x| [x[:last_name], "#{x[:first_name]} #{x[:last_name]}"]}]
  #   "Abbeel" => "Pieter Abbeel",
  #   "Jordan" => "Michael I. Jordan",
  #   "Russell" => "Stuart Russell",
  #   "Goldberg" => "Ken Goldberg",
  #   "Malik" => "Jitendra Malik",
  #   "Darrell" => "Trevor Darrell",
  #   "Dragan" => "Anca Dragan",
  #   "Efros" => "Alyosha Efros",
  #   "Klein" => "Dan Klein",
  # }

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
    .group_by{|x| [x[:first_name], x[:last_name]]}
    .to_a.map{|x| x[1][0].merge(advisor: x[1].map{|y| y[:advisor]}.join(", "))} # join advisors
    .reject{|x| x[:image_url].blank?} # only show the ones with profile image filled in
    .sort_by{|x| x[:last_name]}
    .reject{|x| x[:first_name] == "Dummy"}

end

def ensure_face_images!(sorted_rows)
  base_uri = "https://bair-dev.firebaseio.com"
  cli = Firebase::Client.new(base_uri)
  processed_images = cli.get("processed_images").body || {}
  processed_keys = processed_images.keys
  todo_images = sorted_rows.map{|x| [x[:image_url], x]}.reject{|x| processed_keys.include?(Digest::MD5.hexdigest(x[0]))}

  Cloudinary.config do |config|
    config.cloud_name = ENV["CLOUDINARY_CLOUD_NAME"]
    config.api_key = ENV["CLOUDINARY_API_KEY"]
    config.api_secret = ENV["CLOUDINARY_API_SECRET"]
  end

  todo_images.each do |image_url, content|
    STDERR.puts "Processing #{image_url}..."
    STDERR.puts "Uploading image..."
    begin
      ret = Cloudinary::Uploader.upload image_url
      processed_images = cli.get("processed_images").body || {}
      processed_images[Digest::MD5.hexdigest(image_url)] = ret
      # save after every update
      cli.set("processed_images", processed_images)
    rescue Exception => e
      STDERR.puts e
      STDERR.puts content
      STDERR.puts "Continuing"
    end
  end
  sorted_rows.each do |row|
    unless row[:image_url].blank?
      key = Digest::MD5.hexdigest(row[:image_url])
      if processed_images.include?(key)
        id = processed_images[key]["public_id"]
        row[:cropped_image_url] = Cloudinary::Utils.cloudinary_url(id, width: 200, height: 200, crop: :thumb, gravity: :face, radius: :max, format: "jpg")
      end
    end
  end
  sorted_rows = sorted_rows.reject{|x| x[:cropped_image_url].blank?}
  sorted_rows
end

if __FILE__ == $0
  sorted_rows = get_sorted_rows
  sorted_rows = ensure_face_images!(sorted_rows)
end
