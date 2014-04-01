require 'socket'

server = TCPServer.open(2000)
loop {
    client = server.accept
    response = client.gets
    #puts(response)
    if response.chomp =~ /GET \/index.html HTTP\/1.0/
        file = response.chomp.split(" ")[1][1..-1]
        if File.exists?(file)
            resp = "HTTP/1.0 200 OK\r\n\r\n"
            cont = File.open(file, "r") {|f| f.read}
            resp += "\nContent-Type: text/html\n"
            resp += "Content-Length: #{cont.length}\n"
            resp += cont
            client.puts(resp)
            #puts(resp)
        else
            resp = "HTTP/1.0 404 Not Found\r\n\r\n"
            client.puts(resp)
        end
    else
        resp = "HTTP/1.0 404 Not Found\r\n\r\n"
        client.puts(resp)
    end
    client.close
}
