require 'socket'
require 'json'

server = TCPServer.open(2000)
loop {
    client = server.accept
    response = client.gets
    puts "\n\n\n===========================\n"
    puts response
    puts "\n\n\n===========================\n"
    if response.chomp =~ /GET \/index.html HTTP\/1.0/
        file = response.chomp.split(" ")[1][1..-1]
        if File.exists?(file)
            resp = "HTTP/1.0 200 OK\r\n\r\n"
            cont = File.open(file, "r") {|f| f.read}
            resp += "\nContent-Type: text/html\n"
            resp += "Content-Length: #{cont.length}\n"
            resp += cont
            client.puts(resp)
        else
            resp = "HTTP/1.0 404 Not Found\r\n\r\n"
            client.puts(resp)
        end
    elsif response.chomp.include? "POST /thanks.html HTTP/1.0"
        puts "START"
        headers = ""
        puts client.gets
        #headers = client.gets.split("\n")
        puts headers
        params = JSON.parse(headers[3])
        puts params
        File.open("thanks.html", "w") do |line|
            if line.eql? "<%= yield %>"
                viks = ""
                params.each do |viking|
                    name = "<li>Name: #{viking["name"]}</li>"
                    email = "<li>Email: #{viking["email"]}</li>"
                    viks += "#{name}#{email}<br />"
                end
                line = viks
            end
        end 
        cont = File.open("thanks.html", "r").read
        client.puts(cont)
        puts "DONE"
    else
        resp = "HTTP/1.0 404 Not Found\r\n\r\n"
        client.puts(resp)
    end
    client.close
}
