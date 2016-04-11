require 'oj'
require 'pry'
data = Oj.load_file 'AllSets-x.json'
new_data = {}

class String
  def to_key
    downcase.delete(" ,’'")
  end
end

data.each do |code, set|
  cards = set["cards"]
  cards.each do |c|
    key = c["name"].to_key
    new_data[key] = {
      "lang" => "en",
      "name" => c["name"],
      "card_id" => c["multiverseid"],
      "price_id" => c["multiverseid"],
      "key_en" => key,
    }
    if c["layout"] == "double-faced"
      new_data[key]["back"] = c["names"].reject{|x| x == c["name"]}.first.to_key
    end
    if c["foreignNames"] && (kname = c["foreignNames"].find{|x| x["language"] == "Korean"}) && kname["multiverseid"]
      k_key = kname["name"].to_key
      new_data[k_key] = {
        "lang" => "ko",
        "name" => kname["name"],
        "card_id" => kname["multiverseid"],
        "price_id" => c["multiverseid"],
        "key_en" => key,
        "key_ko" => k_key,
      }
      new_data[key]["key_ko"] = k_key
    end
  end
end
File.write "all.json", Oj.dump(new_data)
