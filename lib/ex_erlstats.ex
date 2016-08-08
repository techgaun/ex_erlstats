defmodule ExErlstats do
  @moduledoc """
  A simple module to get erlang VM stats
  """
  def get do
    %{
      memory: memory,
      system: system_info
    }
  end

  def memory(key) do
    memory[key]
  end
  def memory do
    :erlang.memory
    |> Enum.into(%{})
  end

  def system_info(key) do
    system_info[key]
  end
  def system_info do
    [:check_io, :otp_release, :port_count, :port_limit, :process_count, :process_limit]
    |> Stream.map(fn x ->
      {x, :erlang.system_info(x)}
    end)
    |> Enum.into(%{})
  end
end
