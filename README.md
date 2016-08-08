# ExErlstats [![Hex version](https://img.shields.io/hexpm/v/ex_erlstats.svg "Hex version")](https://hex.pm/packages/ex_erlstats) ![Hex downloads](https://img.shields.io/hexpm/dt/ex_erlstats.svg "Hex downloads")

> Get statistics about Erlang VM

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `ex_erlstats` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ex_erlstats, "~> 0.1.0"}]
    end
    ```

  2. Ensure `ex_erlstats` is started before your application:

    ```elixir
    def application do
      [applications: [:ex_erlstats]]
    end
    ```

## Examples

You can get information about
- memory such as total allocated memory, total amount of memory allocated for atoms, etc.
- system such as port limits, current port counts, processes counts, etc.
- erlang statistics such as total run queue length, total active tasks, etc.

```shell
> ExErlstats.get_all
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
    otp_release: '19', port_count: 5, port_limit: 65536, process_count: 49,
    process_limit: 262144, schedulers: 4, schedulers_online: 4, version: '8.0'}}

> ExErlstats.stats                     
%{run_queue: 0, run_queue_lengths: [0, 0, 0, 0],
  scheduler_wall_time: :undefined, total_active_tasks: 1,
  total_run_queue_lengths: 0}

> ExErlstats.stats[:total_active_tasks]
1

> ExErlstats.system_info
%{check_io: [name: :erts_poll, primary: :poll, fallback: false,
   kernel_poll: false, memory_size: 66200, total_poll_set_size: 3,
   lazy_updates: true, pending_updates: 0, batch_updates: false,
   concurrent_updates: false, max_fds: 1024, active_fds: 0], otp_release: '19',
  port_count: 5, port_limit: 65536, process_count: 49, process_limit: 262144,
  schedulers: 4, schedulers_online: 4, version: '8.0'}

> ExErlstats.system_info[:port_count]
5

> ExErlstats.memory                  
%{atom: 388625, atom_used: 367118, binary: 170776, code: 9396647, ets: 598128,
  processes: 6469296, processes_used: 6468312, system: 16370224,
  total: 22839520}

> ExErlstats.memory[:total]
22827520
```
