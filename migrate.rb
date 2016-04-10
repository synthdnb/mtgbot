require 'oj'
require 'pry'
data = Oj.load_file 'AllSets-x.json'
new_data = {}

data.each do |code, set|
  cards = set["cards"]
  cards.each do |c|
    if c["foreignNames"] && (kname = c["foreignNames"].find{|x| x["language"] == "Korean"}) && kname["multiverseid"]
      new_data[kname["name"].downcase.delete(" ").delete(",")] = {
        "name" => kname["name"],
        "card_id" => kname["multiverseid"],
        "price_id" => c["multiverseid"]
      }
    end
    new_data[c["name"].downcase.delete(" ").delete(",")] = {
      "name" => c["name"],
      "card_id" => c["multiverseid"],
      "price_id" => c["multiverseid"]
    }
  end
end

File.write "all.json", Oj.dump(new_data)
