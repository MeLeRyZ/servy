defmodule Servy.Handler do
    def handle(request) do
        request |> parse |> route |> format_response
    end

    def parse(request) do
        [method, path, _] =
                    request
                    |> String.split("\n")
                    |> List.first
                    |> String.split(" ")
        %{ method: method, path: path, resp_body: ""}
    end

    def route(conv) do
        conv = %{ method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Pigeons"}
        # > conv.path - only works if the key is atom
    end

    def format_response(conv) do
        """
        HTTP/1.1 200 OK
        Content-Type: text/html
        Content-Length: 20

        Bears, Lions, Pigeons
        """
    end

end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)
IO.puts response
