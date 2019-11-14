require "minitest/autorun"
require "./sim.rb"

class TestSim < MiniTest::Test
# Rule 1a
  def test_lines_config
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
  	expected_lines = {
  				"red"=>["Davis", 
  						"Harvard", 
  						"Kendall", 
  						"Park", 
  						"Downtown Crossing", 
  						"South Station", 
  						"Broadway", 
  						"Andrew", 
  						"JFK"], 
  				"green"=>["Tufts", 
  						  "Magoun", 
  						  "East Sommerville", 
  						  "Lechmere", 
  						  "North Station", 
  						  "Government Center", 
  						  "Park", 
  						  "Boylston", 
  						  "Arlington", 
  						  "Copley"], 
  				"blue"=>["Bowdoin", 
  						 "Government Center", 
  						 "State", 
  						 "Aquarium", 
  						 "Maverick", 
  						 "Airport"], 
  				"orange"=>["Ruggles", 
  						   "Back Bay", 
  						   "Tufts Medical Center", 
  						   "Chinatown", 
  						   "Downtown Crossing", 
  						   "State", 
  						   "North Station", 
  						   "Community College", 
  						   "Sullivan"]
  				}

    the_T.config_sim({"Alice" => ["Davis", "Kendall"],
                  	  "Bob" => ["Park", "Tufts"],
                  	  "Carol" => ["Maverick", "Davis"],
                  	  "Dan" => ["Ruggles", "Aquarium", "East Sommerville"]
                     })

    assert_equal expected_lines, the_T.lines
    assert_equal "Alice", the_T.passengers.shift.passenger
    assert_equal "Bob", the_T.passengers.shift.passenger
    assert_equal "Carol", the_T.passengers.shift.passenger
    assert_equal "Dan", the_T.passengers.shift.passenger
    #need to test their paths
	end

# Rule 1b
	def test_passenger_paths
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
		   	 
		    assert_equal ["Davis", "Kendall"], the_T.passengers.shift.plan.keys
    		assert_equal ["Park", "Tufts"], the_T.passengers.shift.plan.keys
    		assert_equal ["Maverick", "Government Center", "Park", "Davis"], the_T.passengers.shift.plan.keys
    		assert_equal ["Ruggles", "North Station", "East Sommerville"], the_T.passengers.shift.plan.keys
    end

# Rule 2
	def test_one_train_each_line
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

		assert_equal "red", the_T.stations.at(0).train.get_train
		assert_nil the_T.stations.at(1).train.get_train
		assert_nil the_T.stations.at(2).train.get_train
		assert_nil the_T.stations.at(3).train.get_train
		assert_nil the_T.stations.at(4).train.get_train
		assert_nil the_T.stations.at(5).train.get_train
		assert_nil the_T.stations.at(6).train.get_train
		assert_nil the_T.stations.at(7).train.get_train
		assert_nil the_T.stations.at(8).train.get_train
		assert_equal "green", the_T.stations.at(9).train.get_train
		assert_nil the_T.stations.at(10).train.get_train
		assert_nil the_T.stations.at(11).train.get_train
		assert_nil the_T.stations.at(12).train.get_train
		assert_nil the_T.stations.at(13).train.get_train
		assert_nil the_T.stations.at(14).train.get_train
		assert_nil the_T.stations.at(15).train.get_train
		assert_nil the_T.stations.at(16).train.get_train
		assert_nil the_T.stations.at(17).train.get_train
		assert_equal "blue", the_T.stations.at(18).train.get_train
		assert_nil the_T.stations.at(19).train.get_train
		assert_nil the_T.stations.at(20).train.get_train
		assert_nil the_T.stations.at(21).train.get_train
		assert_nil the_T.stations.at(22).train.get_train
		assert_nil the_T.stations.at(23).train.get_train
		assert_equal "orange", the_T.stations.at(24).train.get_train
		assert_nil the_T.stations.at(25).train.get_train
		assert_nil the_T.stations.at(26).train.get_train
		assert_nil the_T.stations.at(27).train.get_train
		assert_nil the_T.stations.at(28).train.get_train

		the_T.step(:train, "red")
		the_T.step(:train, "green")
		the_T.step(:train, "orange")
		the_T.step(:train, "blue")

		assert_nil the_T.stations.at(0).train.get_train
		assert_equal "red", the_T.stations.at(1).train.get_train
		assert_nil the_T.stations.at(2).train.get_train
		assert_nil the_T.stations.at(3).train.get_train
		assert_nil the_T.stations.at(4).train.get_train
		assert_nil the_T.stations.at(5).train.get_train
		assert_nil the_T.stations.at(6).train.get_train
		assert_nil the_T.stations.at(7).train.get_train
		assert_nil the_T.stations.at(8).train.get_train
		assert_nil the_T.stations.at(9).train.get_train
		assert_equal "green", the_T.stations.at(10).train.get_train
		assert_nil the_T.stations.at(11).train.get_train
		assert_nil the_T.stations.at(12).train.get_train
		assert_nil the_T.stations.at(13).train.get_train
		assert_nil the_T.stations.at(14).train.get_train
		assert_nil the_T.stations.at(15).train.get_train
		assert_nil the_T.stations.at(16).train.get_train
		assert_nil the_T.stations.at(17).train.get_train
		assert_nil the_T.stations.at(18).train.get_train
		assert_equal "blue", the_T.stations.at(19).train.get_train
		assert_nil the_T.stations.at(20).train.get_train
		assert_nil the_T.stations.at(21).train.get_train
		assert_nil the_T.stations.at(22).train.get_train
		assert_nil the_T.stations.at(23).train.get_train
		assert_nil the_T.stations.at(24).train.get_train
		assert_equal "orange", the_T.stations.at(25).train.get_train
		assert_nil the_T.stations.at(26).train.get_train
		assert_nil the_T.stations.at(27).train.get_train
		assert_nil the_T.stations.at(28).train.get_train
	end

# Rule 3
	def test_one_train_each_line
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

		   assert_equal "Davis", the_T.locate_train("red").station
		   assert_equal "Tufts", the_T.locate_train("green").station
		   assert_equal "Bowdoin", the_T.locate_train("blue").station
		   assert_equal "Ruggles", the_T.locate_train("orange").station
		   assert_equal "Davis", the_T.stations.at(0).station
		   assert_equal "Park", the_T.stations.at(3).station
		   assert_equal "Maverick", the_T.stations.at(21).station
		   assert_equal "Ruggles", the_T.stations.at(23).station
		   assert_equal "Alice", the_T.stations.at(0).passengers.first.passenger
		   assert_equal "Bob", the_T.stations.at(3).passengers.first.passenger
		   assert_equal "Carol", the_T.stations.at(21).passengers.first.passenger
		   assert_equal "Dan", the_T.stations.at(23).passengers.first.passenger
	end

# Rule 4
	def test_train_reverse
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
			
			# Test Red Line
			assert_equal "Davis", the_T.locate_train("red").station
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			assert_equal "JFK", the_T.locate_train("red").station
			the_T.step(:train, "red")
			assert_equal "Andrew", the_T.locate_train("red").station
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			assert_equal "Davis", the_T.locate_train("red").station

			# Test Green Line
			assert_equal "Tufts", the_T.locate_train("green").station
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			assert_equal "Copley", the_T.locate_train("green").station
			the_T.step(:train, "green")
			assert_equal "Arlington", the_T.locate_train("green").station
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			the_T.step(:train, "green")
			assert_equal "Tufts", the_T.locate_train("green").station

			# Test Blue Line
			assert_equal "Bowdoin", the_T.locate_train("blue").station
			the_T.step(:train, "blue")
			the_T.step(:train, "blue")
			the_T.step(:train, "blue")
			the_T.step(:train, "blue")
			the_T.step(:train, "blue")
			assert_equal "Airport", the_T.locate_train("blue").station
			the_T.step(:train, "blue")
			assert_equal "Maverick", the_T.locate_train("blue").station
			the_T.step(:train, "blue")
			the_T.step(:train, "blue")
			the_T.step(:train, "blue")
			the_T.step(:train, "blue")
			assert_equal "Bowdoin", the_T.locate_train("blue").station

			# Test Orange Line
			assert_equal "Ruggles", the_T.locate_train("orange").station
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			assert_equal "Sullivan", the_T.locate_train("orange").station
			the_T.step(:train, "orange")
			assert_equal "Community College", the_T.locate_train("orange").station
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			the_T.step(:train, "orange")
			assert_equal "Ruggles", the_T.locate_train("orange").station
	end

# Rule 5- Rather than using assert methods, the print statements generated by
# functions from Class Log show that at each step, exactly one thing happens. 
	def test_discrete_steps
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
	end

# Rule 6
	def test_
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
                  			  "Bob" => ["Davis", "Park"],
                  		      "Carol" => ["Davis", "Maverick"],
                  			  "Dan" => ["Davis", "Sullivan"]
                 			  })

		    assert_equal "Davis", the_T.stations.at(0).station
		    assert_equal "Alice", the_T.stations.at(0).passengers.shift.passenger
		    assert_equal "Bob", the_T.stations.at(0).passengers.shift.passenger
		    assert_equal "Carol", the_T.stations.at(0).passengers.shift.passenger
		    assert_equal "Dan", the_T.stations.at(0).passengers.first.passenger
	end

# Rule 7
	def test_same_station
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

			assert_equal "Davis", the_T.locate_train("red").station
			the_T.step(:passenger, "Alice")
			assert_equal "Alice", the_T.locate_train("red").train.passengers.first.passenger
			the_T.step(:train, "red")
			the_T.step(:train, "red")
			the_T.step(:passenger, "Alice")
			assert_equal "Kendall", the_T.locate_train("red").station
			assert_equal "Alice", the_T.stations.at(2).passengers.first.passenger
	end

# Rule 8
	def test_move_if_progress
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
                  			  "Bob" => ["Tufts", "Park"],
                  		      "Carol" => ["Maverick", "Davis"],
                  			  "Dan" => ["Ruggles", "Aquarium", "East Sommerville"]
                 			  })
		assert_equal "Tufts", the_T.locate_train("green").station
		the_T.step(:passenger, "Bob")
		assert_equal "Bob", the_T.locate_train("green").train.passengers.first.passenger
		the_T.step(:train, "green")
		assert_equal "Magoun", the_T.locate_train("green").station
		the_T.step(:passenger, "Bob")
		assert_equal "Bob", the_T.locate_train("green").train.passengers.first.passenger
		the_T.step(:train, "green")
		the_T.step(:train, "green")
		the_T.step(:train, "green")
		the_T.step(:train, "green")
		the_T.step(:train, "green")
		the_T.step(:passenger, "Bob")
		assert_equal "Park", the_T.locate_train("green").station
		assert_equal "Bob", the_T.stations.at(3).passengers.first.passenger
	end

# Rule 9
	def test_passengers_at_final_stops
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

			assert_equal "Alice", the_T.stations.at(2).passengers.first.passenger
			assert_equal "Bob", the_T.stations.at(9).passengers.first.passenger
			assert_equal "Carol", the_T.stations.at(0).passengers.first.passenger
			assert_equal "Dan", the_T.stations.at(11).passengers.first.passenger
	end

# I will not dedicate an additional function to testing Rule 10 simply because in other functions
# the Log methods are used to print messages as trains and passengers move.  
end

