require 'pry'
require 'uri'
require 'net/http'
require 'date'

start_date = Date.today
#end_date   =  Date.new(2007, 11, 1)
end_date   =  Date.new(2015, 6, 1)

current_date = start_date

def get_xml_for_date(date)
  uri = URI('http://www.wsdot.wa.gov/traffic/bridges/WeatherHistory.aspx?bridge=SR+520')
  res = Net::HTTP.post_form(uri,
                            "__VIEWSTATE" => "/wEPDwUKMTgyNzE2OTU1NGRkGCGtxCVmYlz0YXF2Z/dxjk8n6Uo=",
                            "__VIEWSTATEGENERATOR" => "65B5B070",
                            "ctl00$MainContentPlaceHolder$ddlStationList" => "1",
                            "ctl00$MainContentPlaceHolder$PickMonth"      => date.month.to_s.rjust(2, '0'),
                            "ctl00$MainContentPlaceHolder$PickDay"        => date.day.to_s.rjust(2, '0'),
                            "ctl00$MainContentPlaceHolder$PickYear"       => date.year.to_s.rjust(2, '0'),
                            "ctl00$MainContentPlaceHolder$BtnDownload"    => "Download",
                           )
  return res
  
end

def file_path(date)
  "history/#{date}-wsdot-520.xml"
end

def save_xml(date, xml)
  print "Writing #{date}-wsdot-520.xml #{xml.size} bytes... "
  File.open(file_path(date), 'w') do |f|
    f.write(xml)
  end
  puts "Done!"
end

while current_date > end_date
  if File.exist?(file_path(current_date))
    puts "Already have #{current_date}"
  else
    print "Fetching #{current_date}... "
    st = Time.now
    res = get_xml_for_date(current_date)
    puts  " Status: " + res.code.to_s + "\t Sec:" + (Time.now-st).round(1).to_s
    
    if res.code.to_i == 200
      save_xml(current_date, res.body)
      puts "Sleeping..."
      sleep(1) # don't hit them too hard
    end
  end
  
  current_date = current_date.prev_day
  if current_date.month
    
  end
  
end

