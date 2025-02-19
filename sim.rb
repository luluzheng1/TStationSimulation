require "set"
# This program is an implementation of a simulation of the T. The four classes Passenger, Train,
# Station, and Trainsit represent people riding the trains, the trains themselves, the stations, 
# and the T system, respectively.
# I use BFS to determine the shortest path between two stations, given a starting station 
# and destination station. Classes BFS, Graph, and Node are dedicated to finding
# the shortest path to get to any two stations. 
# Class Log exists for debugging purposes. 

class Transit
  # Initialization functions

  # Creates a new transit system given lines, a map from line names (strings)
  # to lists of their stations (an array of strings).
  def initialize(lines)
    @lines = lines
    @trains = initialize_trains
    @stations = initialize_stations
    @transfer = initialize_transfer
    @node_array = Array.new
    @graph = Graph.new
    initialize_nodes
    make_graph
  end

  # Configures the starting state of the simulation with paths, a map from
  # passenger names to their paths, which are lists of the stations they want
  # to visit. 
  def config_sim(paths)
    @paths = paths
    @passengers = initialize_passengers

    # Plan each passenger's trip
    passengers.each_with_index { |x, index|
      s1 = paths[x.passenger].first
      s2 = paths[x.passenger].last
      p = plan(s1, s2)
      c = color(plan(s1,s2))
      x.set_plan(Hash[p.zip(c.map {|i| i.include?(',') ? (i.split /, /) : i})])
      # when passenger has more than 2 stops?
    }
    
    i = 0
    @paths.each {|name, path|
      #find the station in the first index of path array
      @stations.each {|x| 
        if x.to_s.include? path.first
          #add Passenger in passenger attribute of that station
          x.add_passenger(@passengers.at(i))
          i += 1
        end
        }
    }
  end

  # Initializes stations object as a list of Stations in the transit system
  def initialize_stations
    @stations = Array.new
    i = 0

    @lines.each {|line, stations|
      stations.each_with_index {|item, index|
        @stations.push(Station.new(item))
        if index == 0
          @stations.at(-1).set_train(@trains.at(i))
          i += 1
        end
        }
    }

    @stations = @stations.uniq { |s| s.station.to_s}
  end

  # Creates an array of transfer stations
  def initialize_transfer
    @temp = Array.new

    @lines.each {|line, stations|
      stations.each_with_index {|item, index|
        @temp.push(item)
      }
    }

    return @temp.select {|e| @temp.count(e) > 1}.uniq
  end

  # Initialize trains object as a list of Trains in the transit system
  def initialize_trains
    @trains = Array.new

    @lines.each {|line, stations|
      @trains.push(Train.new(line))
    }
    
    return @trains
  end

  def initialize_passengers
    @passengers = Array.new

    @paths.each {|name, path|
      @passengers.push(Passenger.new(name))
    }

    return @passengers
  end

  # Creates a node for every unique station and stores the nodes in an array
  def initialize_nodes
    stations.each {|x|
        node.push(Node.new(x.station))
      }
  end

  # Creates a graph connecting a station to another station
  def make_graph
    lines.each {|line, stations|
      stations.each_with_index {|x, index|
        unless stations.at(index+1).nil?
          graph.add_edge(find_node(x), find_node(stations.at(index+1)))
        end
      }
    }
  end

  # Returns a array of the color of lines that correspond to the Passenger's path
  def color(path)
    color_array = Array.new

    path[0...-1].each_with_index {|x, index|
      lines_curr = Array.new
      lines_next = Array.new
      lines_curr = lines_at_station(x)
      lines_next = lines_at_station(path[index+1])
      color_array.push((lines_curr & lines_next).first)
      }

    return color_array
  end

  # Runs one step of simulation, depending on the arguments
  # If kind == :train, then the train named name should take one step in the
  # direction it's traveling if possible; step returns true. If the train 
  # cannot move because the next station is already occupied by another train),
  # step returns false.
  # If kind == :passenger, then the passenger named name should either board
  # or exist a train if they would make progress; step returns true. If the
  # passenger would not make progress, this call to step has no effect and returns
  # false  
  def step(kind, name)
    progress = false
    if kind == :train
        curr_station = locate_train(name)

        index = station_index(curr_station, name)
        #check if need to update rev
        if curr_station.station == lines[name].last
          curr_station.train.set_rev(true)
        end
        if curr_station.station == lines[name].first
          curr_station.train.set_rev(false)
        end
         
        if curr_station.train.rev? == false
          next_station = lines[name][index+1]
        else
          next_station = lines[name][index-1]
        end

        stations.each {|station|
          if (station.to_s == next_station) && station.train.nil?
            station.set_train(curr_station.train)
            curr_station.remove_train
            progress = true
            Log.train_moves(name, curr_station.station, next_station)
            break
          end
          }

      if progress == false 
        conflincting_train = (stations.select {|e| e.station == next_station}).first.train.to_s
        puts "Train " + curr_station.train.get_train + " cannot advance, " + conflincting_train + " train at " + next_station 
      end 
    elsif kind == :passenger
      person = nil
      # Find passenger object
      passengers.each {|x|
        if x.passenger == name
          person = x
        end
      }

      stations.each {|x|
        if x.passengers.include? person
          if !(x.train.nil?)
            if x.train.get_train == person.plan[x.station]
              x.train.add_passenger(person)
              x.remove_passenger(person)
              person.delete_pair(x.station)
              progress = true
              Log.passenger_boards(person.passenger,x.train.get_train,x.station) 
            end
          end
        elsif !(x.train.nil?) 
          if (x.train.passengers.include? person) && (person.plan.has_key?(x.station))
            x.add_passenger(person)
            x.train.remove_passenger(person)
            if (person.plan)[x.station].nil?
              person.delete_pair(x.station)
            end
            progress = true
            Log.passenger_exits(person.passenger, x.train.get_train, x.station)
          end
        end
      }
    else
      puts "Error, kind type not recognized."
    end

    return progress
  end
    
  # Returns the station that the train named name is currently at
  def locate_train(name)
    stations.each { |station|
      if station.train.to_s.include? name
        return station
      end
    }
  end

  # Returns the index at which the station is stored in an array of the hashmap
  def station_index(station, name)
    lines.each {|line, stations|
      if line == name
        stations.each_with_index {|x, index|
          if x == station.to_s
            return index
          end
        }
      end
    }
  end

  # Returns true if the simulation is complete (all passengers are at their)
  # final destinations), and otherwise it returns false. 
  def finished?
    return passengers.all? {|x| x.plan.empty? }
  end

  # Get Functions

  # Returns a list of the Stations in the transit system
  def stations
    return @stations
  end

  def trains
    return @trains
  end

  def lines
    return @lines
  end

  def paths
    return @paths
  end

  def passengers
    return @passengers
  end

  def transfer
    return @transfer
  end

  def node
    return @node_array
  end

  def graph
    return @graph
  end

  def find_node(name)
    node.each{|x|
      if x.name == name
        return x
      end
    }
  end
  
  # Takes two stations and returns an array of strings containing a sequence of 
  # stations where a passenger going from s1 to s2 should board; change trains; 
  # and exit.
  def plan(s1, s2)
    if s1 == s2
      return []
    end

    condensed_path = Array.new
    full_path = Array.new
    temp = BFS.new(graph, find_node(s1)).shortest_path_to(find_node(s2))

    temp.each {|x| full_path.push(x.to_s)}
    condensed_path.push(full_path.first)
    condensed_path = condensed_path + transfer_stations(full_path)
    
    if condensed_path.last != full_path.last #need to test this more
      condensed_path << full_path.last
    end

  return condensed_path
  end

        
  # Return an array of transfer stations given a path, includes the last stop
  # regardless of transfering 
  def transfer_stations(path)
    lines_path = Array.new
    condensed_path = Array.new

    path[0...-1].each_with_index {|x, index|
      lines_curr = Array.new
      lines_next = Array.new
      lines_curr = lines_at_station(x)
      lines_next = lines_at_station(path[index+1])
      lines_path.push((lines_curr & lines_next).first)
      }

    lines_path.each_with_index {|x, index|
      if (x != lines_path[index +1]) && (transfer.include? path[index +1])
        condensed_path.push(path[index+1])
      end
    }

    return condensed_path
  end

  # Returns an array of lines the station is on
  def lines_at_station(station)
    line_array = Array.new

    lines.each {|lines, stations|
      stations.each {|x| 
        if x == station
          line_array.push(lines)
        end 
      } 
    }

    return line_array
  end
end

class Station
  attr_accessor :station
  # Passengers is a list of Passenger objects currently at the station
  # Train is the Train object currently at the station, nil if there is
  # no train at the station
  def initialize(station)
    @station = station
    @train = nil
    @passengers = Array.new
  end

  def add_passenger(passenger)
    passengers.push(passenger)
  end

  def remove_passenger(passenger)
    @passengers.delete(passenger)
  end

  # Sets train to train object currently at station 
  def set_train(train)
    @train = train
  end

  def remove_train
    @train = nil
  end

  def station
    return @station
  end

  # Returns a list (array) of Passenger objects currently at the station
  def passengers
    return @passengers
  end

  # Returns the train that is currently at the station, or nil if there
  # is no train at the station
  def train
    return @train
  end

  # Returns the station name
  def to_s
    return "#{@station}"
  end
end

class Train
  # Passengers is a list of Passenger objects currently on the train
  def initialize(line)
    @train = line
    @passengers = Array.new
    @rev = false
  end

  def get_train
    return @train
  end

 # Adds a passenger object to the passenger array
  def add_passenger(passenger)
    @passengers.push(passenger)
  end

  def remove_passenger(passenger)
    @passengers.delete(passenger)
  end

  # Returns a list (array) of Passenger objects currently on the train
  def passengers 
    return @passengers
  end

  # Determines whether train needs to reverse directions
  def rev?
    return @rev
  end

  def set_rev(rev)
    @rev = rev
  end

  # Returns the name of the line the train is running on
  def to_s
    return "#{@train}"
  end
end

class Passenger
  def initialize(passenger)
    @passenger = passenger
    @plan = Hash.new
  end

  def passenger
    return @passenger
  end

  def plan
    return @plan
  end

  def set_plan(plan)
    @plan = plan
  end

  def delete_pair(key)
    @plan.delete(key)
  end

  def to_s
    return "#{@passenger}"
  end
end

class Log
  def self.train_moves(t, s1, s2)
    puts "Train #{t} moves from #{s1} to #{s2}"
  end

  def self.passenger_boards(p, t, s)
    puts "Passenger #{p} boarding train #{t} at #{s}"
  end

  def self.passenger_exits(p, t, s)
    puts "Passenger #{p} exiting train #{t} at #{s}"
  end
end

# Class BFS uses a queue to find the shortest path from source node to
# target node using the fewest number of edges. BFS puts an unvisited 
# node in a queue and mark it as visited and repeatedly remove the least
# recently added node n and add each of n's unvisited adjacents to the 
# queue and mark them as visited.  
class BFS
  def initialize(graph, source_node)
    @graph = graph
    @node = source_node
    @visited = []
    @edge_to = {}

    bfs(source_node)
  end

  def shortest_path_to(node)
    return unless has_path_to?(node)
    path = []

    while(node != @node) do
      path.unshift(node) # Add node to start of array
      node = @edge_to[node]
    end

    path.unshift(@node)
  end

  private
  def bfs(node)
    # Shift removes an element from beginning of Array.

    queue = []
    queue << node
    @visited << node

    while queue.any?
      current_node = queue.shift # remove first element
      current_node.adjacents.each do |adjacent_node|
        next if @visited.include?(adjacent_node)
        queue << adjacent_node
        @visited << adjacent_node
        @edge_to[adjacent_node] = current_node
      end
    end
  end

  def has_path_to?(node)
    @visited.include?(node)
  end
end

# For each pair of adjacent stations, Graph creates a connection
# between the two stations
class Graph

  def add_edge(node_a, node_b)
    node_a.adjacents << node_b
    node_b.adjacents << node_a
  end
end

# For each station, Node creates a node that stores the station's
# neighboring stations
class Node
  attr_accessor :name, :adjacents

  def initialize(name)
    @adjacents = Set.new
    @name = name
  end

  def to_s
    @name
  end
end

