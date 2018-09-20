defmodule BattleNetwork.Link do
    alias BattleNetwork.HTTP
    require Logger
  
    def get(url), do: unwrap(:get, url)
    def head(url), do: unwrap(:head, url)
    def post(url), do: unwrap(:post, url)
    def post(url, data), do: unwrap(:post, url, data)
    def put(url), do: unwrap(:put, url)
    def put(url, data), do: unwrap(:put, url, data)
    def patch(url), do: unwrap(:patch, url)
    def patch(url, data), do: unwrap(:patch, url, data)
    def delete(url), do: unwrap(:delete, url)
    def delete(url, data), do: unwrap(:delete, url, data)
  
    @doc false
    defp unwrap(action, url, data \\ %{}, headers \\ []) do
      with {:ok, %{body: body, status_code: 200}} <-
             HTTP.request(
               action,
               url,
               data,
               headers,
               timeout: 100_000,
               recv_timeout: 100_000
             ) do
        {:ok, body}
      else
        err ->
          err
      end
    end
  end