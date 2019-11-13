require "./sim.rb"

the_T = Transit.new({
                      "red" => ["Davis",
                                "Harvard",
                                "Kendall",
                                "Park",
                                "Downtown Crossing",
                                "South Station",
                                "Broadway",
                                "Andrew",
                                "JFK"],
                      "green" => ["Tufts",
                                  "Magoun",
                                  "East Sommerville",
                                  "Lechmere",
                                  "North Station",
                                  "Government Center",
                                  "Park",
                                  "Boylston",
                                  "Arlington",
                                  "Copley"],
                      "blue" => ["Bowdoin",
                                 "Government Center",
                                 "State",
                                 "Aquarium",
                                 "Maverick",
                                 "Airport"],
                      "orange" => ["Ruggles",
                                   "Back Bay",
                                   "Tufts Medical Center",
                                   "Chinatown",
                                   "Downtown Crossing",
                                   "State",
                                   "North Station",
                                   "Community College",
                                   "Sullivan"]
                    })

the_T.config_sim({"Alice" => ["Davis", "Kendall"],
                  "Bob" => ["Park", "Tufts"],
                  "Carol" => ["Maverick", "Davis"],
                  "Dan" => ["Ruggles", "Aquarium", "East Sommerville"]
                 })

until the_T.finished?
  ["Alice", "Bob", "Carol", "Dan"].each { |p|
    the_T.step(:passenger, p)
  }
  ["red", "green", "blue", "orange"].each { |t|
    the_T.step(:train, t)
  }
end