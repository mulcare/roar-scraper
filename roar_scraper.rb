require 'open-uri'
require 'nokogiri'
require 'json'

def scrape_scenario(scenario_id)

  doc = Nokogiri::HTML(open("http://www.jrvdev.com/ROAR/VER1/ShowScenario.asp?ScenarioID=#{scenario_id}"))
  
  # Some data has a specific css class for easy scraping.
  scenario_name = doc.at_css("td.ScenarioName").inner_html
  scenario_id = doc.at_css("td.ScenarioNumber").inner_html
  scenario_source = doc.at_css("td.ScenarioPublication").inner_html
  scenario_source_issue = doc.at_css("td.ScenarioIssue").inner_html

  # Wins, losses, and side names are buried in tables so we must pull down all <td> and <th> elements to grab the relevant data.
  winloss = doc.xpath("//td")
  side_a_wins = winloss[18].inner_html
  side_b_wins = winloss[19].inner_html
  sides = doc.xpath("//th")
  side_a_name = sides[0].inner_html.chomp(" wins")
  side_b_name = sides[1].inner_html.chomp(" wins")

  # output
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

scrape_scenario(ARGV[0].to_i)
