defmodule Crawler.Worker do
  def process_uri(uri, referrer) do
    ConCache.get(:uri_results, uri)
    |> case do
      nil ->
        {:ok, {{_, status_code, _}, _, _}} =
          uri
          |> to_char_list
          |> :httpc.request
        ConCache.insert_new(:uri_results, uri, {status_code, [referrer]})
      {status_code, referrers} when is_list(referrers) and is_number(status_code) ->
        ConCache.update(:uri_results, uri, fn {status_code, referrers} -> 
          {:ok, {status_code, [referrer|referrers]}} end)
    end
  
  end
end
