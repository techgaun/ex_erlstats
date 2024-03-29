defmodule ExErlstats do
  @moduledoc """
  A simple module to get erlang VM stats
  """

  @doc """
  ## Example

      iex> ExErlstats.get_all
      %{memory: %{atom: 388625, atom_used: 365825, binary: 49296, code: 9059496,
      ets: 573344, processes: 6593256, processes_used: 6592272, system: 15867984,
      total: 22461240},
      stats: %{run_queue: 0, run_queue_lengths: [0, 0, 0, 0],
      scheduler_wall_time: :undefined, total_active_tasks: 1,
      total_run_queue_lengths: 0},
      system: %{check_io: [name: :erts_poll, primary: :poll, fallback: false,
       kernel_poll: false, memory_size: 66200, total_poll_set_size: 3,
       lazy_updates: true, pending_updates: 0, batch_updates: false,
       concurrent_updates: false, max_fds: 1024, active_fds: 0],
      otp_release: "19", port_count: 5, port_limit: 65536, process_count: 49,
      process_limit: 262144, schedulers: 4, schedulers_online: 4, version: "8.0"}}
  """
  def get_all do
    %{
      memory: memory(),
      system: system_info(),
      stats: stats(),
      processes: processes()
    }
  end

  @doc """
  ## Example

      iex> ExErlstats.memory[:total]
      22827520
  """
  def memory(key) do
    memory()[key]
  end

  @doc """
  ## Example

      iex> ExErlstats.memory
      %{atom: 388625, atom_used: 367118, binary: 170776, code: 9396647, ets: 598128,
        processes: 6469296, processes_used: 6468312, system: 16370224,
        total: 22839520}
  """
  def memory do
    :erlang.memory()
    |> Enum.into(%{})
  end

  @doc """
  ## Example

      iex> ExErlstats.system_info[:port_count]
      5
  """
  def system_info(key) do
    system_info()[key]
  end

  @doc """
  ## Example

      iex> ExErlstats.system_info
      %{check_io: [name: :erts_poll, primary: :poll, fallback: false,
         kernel_poll: false, memory_size: 66200, total_poll_set_size: 3,
         lazy_updates: true, pending_updates: 0, batch_updates: false,
         concurrent_updates: false, max_fds: 1024, active_fds: 0], otp_release: "19",
        port_count: 5, port_limit: 65536, process_count: 49, process_limit: 262144,
        schedulers: 4, schedulers_online: 4, version: "8.0"}
  """
  def system_info do
    [
      :check_io,
      :otp_release,
      :port_count,
      :port_limit,
      :process_count,
      :process_limit,
      :schedulers,
      :schedulers_online,
      :version
    ]
    |> Stream.map(fn x ->
      {x, charlist_to_str({x, :erlang.system_info(x)})}
    end)
    |> Enum.into(%{})
  end

  @doc """
  ## Example

      iex> ExErlstats.stats[:total_active_tasks]
      1
  """
  def stats(key) do
    stats()[key]
  end

  @doc """
  ## Example

      iex> ExErlstats.stats
      %{run_queue: 0, run_queue_lengths: [0, 0, 0, 0],
        scheduler_wall_time: :undefined, total_active_tasks: 1,
        total_run_queue_lengths: 0}
  """
  def stats do
    [
      :run_queue,
      :run_queue_lengths,
      :scheduler_wall_time,
      :total_active_tasks,
      :total_run_queue_lengths
    ]
    |> Stream.map(fn x ->
      {x, :erlang.statistics(x)}
    end)
    |> Enum.into(%{})
  end

  @doc """
  ## Example

      iex> ExErlstats.processes
      [[memory: 21640, heap_size: 1598, total_heap_size: 2585, message_queue_len: 0,
      registered_name: :init]]
  """
  def processes do
    Process.list()
    |> Stream.map(&processes/1)
    |> Enum.filter(fn process_detail ->
      Enum.all?(process_detail, &(not is_nil(&1)))
    end)
  end

  @doc """
  ## Example

      iex> ExErlstats.processes(#PID<0.0.0>)
      [memory: 21640, heap_size: 1598, total_heap_size: 2585, message_queue_len: 0,
      registered_name: :init]
  """
  def processes(pid) do
    items =
      ~w(pid memory heap_size total_heap_size message_queue_len registered_name status stack_size reductions current_function initial_call)a

    for k <- items do
      if k == :pid do
        {k, inspect pid}
      else
        case Process.info(pid, k) do
          {^k, {m, f, ac}} -> {k, "#{m}.#{f}/#{ac}"}
          kv -> kv
        end
      end
    end
    |> maybe_add_gproc_info(pid)
    |> maybe_add_dictionary_initial_call(pid)
  end

  # refer to: https://github.com/uwiger/gproc/wiki/The-gproc-api
  defp maybe_add_gproc_info(kw, pid) do
    if Code.ensure_loaded?(:gproc) do
      case :gproc.info(pid, :gproc) do
        {:gproc, [{{type, scope, name}, _} | _]} ->
          kw
          |> Keyword.put(:gproc_type, type)
          |> Keyword.put(:gproc_scope, scope)
          |> Keyword.put(:gproc_name, "#{inspect name}")

        _ ->
          kw
      end
    else
      kw
    end
  end

  defp maybe_add_dictionary_initial_call(kw, pid) do
    case Process.info(pid, :dictionary) do
      {:dictionary, dict} ->
        case Keyword.get(dict, :"$initial_call") do
          {m, f, a} ->
            Keyword.put(kw, :dict_initial_call, "#{m}.#{f}/#{a}")

          _ ->
            kw
        end

      _ ->
        kw
    end
  end

  defp charlist_to_str({k, v}) when k in [:otp_release, :version], do: String.Chars.to_string(v)
  defp charlist_to_str({_k, v}), do: v
end
