require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'json'

#use mechanize to follow all scenario name links here:
#http://www.jrvdev.com/ROAR/VER1/RecordByName.asp


def scrape_scenario(scenario_id)

  #use nokogiri to scrape individual scenario information
  doc = Nokogiri::HTML(open("http://www.jrvdev.com/ROAR/VER1/ShowScenario.asp?ScenarioID=#{scenario_id}"))
  
  #some data has a specific css class for easy scraping
  scenario_name = doc.at_css("td.ScenarioName").inner_html
  scenario_id = doc.at_css("td.ScenarioNumber").inner_html
  scenario_source = doc.at_css("td.ScenarioPublication").inner_html
  scenario_source_issue = doc.at_css("td.ScenarioIssue").inner_html

  #wins and losses are buried in tables so we must pull down all <td> elements
  winloss = doc.xpath("//td")

  side_a_wins = winloss[18].inner_html
  side_b_wins = winloss[19].inner_html

  #side names are buried as well
  sides = doc.xpath("//th")

  side_a_name = sides[0].inner_html.chomp(" wins")
  side_b_name = sides[1].inner_html.chomp(" wins")

  #output (will be JSON eventually)
  puts "#{scenario_name} (#{scenario_id}) [from #{scenario_source} (Issue #{scenario_source_issue}): #{side_a_wins} #{side_a_name} wins / #{side_b_wins} #{side_b_name} wins"

  scenario_info = {
    "name" => scenario_name,
    "id" => scenario_id,
    "publication" => {
      "source" => scenario_source,
      "source_issue" => scenario_source_issue
    },
    "sides" => {
      "side a" => side_a_name,
      "side b" => side_b_name
    },
    "record" => {
      "side a wins" => side_a_wins,
      "side b wins" => side_b_wins
    }
  }

  puts JSON.pretty_generate(scenario_info)
end
scrape_scenario(125)
#i = 1
#until i > 5 
#  scrape_scenario(i)
#  i += 1
#end
