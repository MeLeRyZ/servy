defmodule Servy.Plugins do

    alias Servy.Conv

    def rewrite_path(%Conv{path: "/wildlife" } = conv) do
        %{ conv | path: "/wildthings"}
    end

    def rewrite_path(%Conv{} = conv), do: conv

    def log(%Conv{} = conv),  do:    IO.inspect conv

    @doc """
    Logs 404 requests.
    """
    def track(%Conv{ status: 404, path: path } = conv) do
            IO.puts "Warning: #{path} is in /dev/null"
            conv
    end

    def track(%Conv{} = conv), do: conv
end
