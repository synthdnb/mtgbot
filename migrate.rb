require 'oj'
require 'pry'
data = Oj.load_file 'AllSets-x.json'
new_data = {}

data.each do |code, set|
  cards = set["cards"]
  cards.each do |c|
    if c["foreignNames"] && (kname = c["foreignNames"].find{|x| x["language"] == "Korean"}) && kname["multiverseid"]
      new_data[kname["name"].downcase] = {
        card_id: kname["multiverseid"],
        price_id: c["multiverseid"]
      }
    else
      new_data[c["name"].downcase] = {
        card_id: c["multiverseid"],
        price_id: c["multiverseid"]
      }
    end
  end
end

File.write "all.json", Oj.dump(new_data)
