require 'pry'
require 'uri'
require 'net/http'
require 'nokogiri'
require 'time'

# <GetWindHistory>
#   <WindSpeed>8.000</WindSpeed>
#   <ReadingTime>2015-06-30T00:00:00-07:00</ReadingTime>
#   <WindDirection>198.0</WindDirection>
#   <TempFarhenheit>69.80</TempFarhenheit>
#   <BarametricPressure>30.000</BarametricPressure>
#   <RelativeHumidity>67.0</RelativeHumidity>


class WaWsdotSource
  attr_accessor :dom, :points
  
  def initialize(xml_string)
    @dom = Nokogiri::XML(xml_string)
    prev = nil
    
    @points = @dom.css("GetWindHistory").map do |hist|
      prev.next = prev unless prev.nil?
      
      point = WaWsdotPoint.new(hist)
      point.prev = prev
      prev = point
      
      point
    end
  end
  
end

class WaWsdotPoint
  attr_accessor :next, :prev
  
  def initialize(dom_point)
    @dom_point = dom_point
  end
  
	def date
    Time.parse value_of("ReadingTime")
	end
  
	def hour_of_day
    date.hour + date.min/60.0
	end
  
  def temp
	  value_of("TempFarhenheit").to_f
	end
  
	def pressure
	  value_of("BarametricPressure").to_f
	end
  
	def humidity
	  value_of("RelativeHumidity").to_f
	end
  
	def velocity
	  value_of("WindSpeed").to_f
	end
	
	def direction
    value_of("WindDirection").to_f
	end
  
  def direction_fixed
    if direction < 180
      return direction + 360
    else
      direction
    end
  end
	
	def shifting_right?
    return true if @prev && @prev.direction < direction
	  return false
	end
	
	def shifting_left?
    # If it has shifted zero should we still consider it a shift?
    return true if @prev && @prev.direction > direction
	  return false
	end
	
	def shift_duration
	  last = self
    if shifting_right?
      while last.prev && last.prev.shifting_right?
        last = last.prev
      end
    elsif shifting_left?
      while last.prev && last.prev.shifting_left?
        last = last.prev
      end
    end
    time - last.time
	end
  
  protected
  def value_of(field)
    @dom_point.css(field).first.text
  end
	
end

puts "year,month,day,hod,temp,pressure,direction,dirfixed,speed"

#files = Dir.glob('history/*-wsdot-520.xml').sort
files = ['history/2015-08-25-wsdot-520.xml']
files.each do |file|
  day = WaWsdotSource.new(File.read(file))
  
  
  day.points.each do |p|
    t = p.date
    
    next if p.hour_of_day < 16 || p.hour_of_day > 22
    
    puts [t.year,
          t.month,
          t.day,
          p.hour_of_day,
          p.temp,
          p.pressure,
          p.direction,
          p.direction_fixed,
          p.velocity,
         ].map(&:to_s).join(',')
  end
end

