require 'socket'
require 'json'

hostname = "localhost"
port = 2000

s = TCPSocket.open(hostname, port)

command = ""
while command != "q"
    print "What kind of request? (q to quit) "
    command = gets.chomp
    case command
        when "q" then break
        when "POST" then
            print "Name: "
            name = gets.chomp
            print "Email: "
            email = gets.chomp
            user = {}
            user["name"] = name
            user["email"] = email
            viking = {}
            viking["viking"] = user
            data = viking.to_json
            header = "POST /thanks.html HTTP/1.0\r\n\r\n"
            extra = "Content-Type: text/json\nContent-Length: #{data.length}\n"
            resp = "#{header}#{extra}#{data}"
            s.print resp
            puts s.read.split("\r\n\r\n", 2)[1]
    end
end

s.close
