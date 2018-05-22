defmodule Servy.Handler do

    @moduledoc """
    Handles HTTP requests.
    """
    @pages_path Path.expand("../../pages", __DIR__)

    import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
    import Servy.Parser, only: [parse: 1]
    alias Servy.Conv

    @doc """
    Transforms the request into response.
    """
    def handle(request) do
        request
        |> parse
        |> rewrite_path
        |> log
        |> route
        |> track
        |> format_response
    end

    # def route(conv) do
    #     route(conv, conv.method,  conv.path)
    #     #conv = %{ method: "GET", path: "/wildthings", resp_body: }
    #     # > conv.path - only works if the key is atom
    # end

    def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
        %{ conv | status: 200, resp_body: "Bears, Lions, Pigeons"}
    end

    def route(%Conv{method: "GET", path: "/bears"} = conv) do
        %{ conv | status: 200, resp_body: "Teddy, Slooney, Redditon"}
    end

    def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
        %{ conv | status: 200, resp_body: "Bear #{id}"}
    end

    def route(%Conv{ method: "GET", path: "/about" } = conv) do
            @pages_path
            |> Path.join("about.html")
            |> File.read
            |> handle_file(conv)
    end
        # case File.read(file)  do
        #     {:ok, content} ->
        #         %{ conv | status: 200, resp_body: content }
        #     {:error, :enoent} ->
        #         %{ conv | status: 404, resp_body: "File not found!" }
        #     {:error, reason} ->
        #         %{ conv | status: 500, resp_body: "File error: #{reason}" }
        # end
        #end

        def handle_file({ :ok, content }, conv) do
            %{ conv | status: 200, resp_body: content }
        end

        def handle_file({ :error, :enoent }, conv) do
            %{ conv | status: 404, resp_body: "File not found!" }
        end

        def handle_file({ :error, reason }, conv) do
            %{ conv | status: 500, resp_body: "File error: #{reason}" }
        end

    def route(%Conv{ path: path} = conv) do
        %{ conv | status: 404, resp_body: "No #{path} here!"}
    end

    def format_response(%Conv{} = conv) do
        """
        HTTP/1.1 #{Conv.full_status(conv)}
        Content-Type: text/html
        Content-Length: #{String.length(conv.resp_body) }

        #{conv.resp_body}
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

request = """
GET /bears HTTP/1.1
Host: example.com
User-agent: ExampleBrowser/1.0
Accept: */*
"""
response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-agent: ExampleBrowser/1.0
Accept: */*
"""
response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-agent: ExampleBrowser/1.0
Accept: */*
"""
response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /about HTTP/1.1
Host: example.com
User-agent: ExampleBrowser/1.0
Accept: */*
"""
response = Servy.Handler.handle(request)
IO.puts response
