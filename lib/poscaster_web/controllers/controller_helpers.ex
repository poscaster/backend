defmodule PoscasterWeb.ControllerHelpers do
  @moduledoc """
  A module that keeps some common controller helper functions (mostly paging-related)
  """

  alias Plug.Conn

  @doc """
  Extracts page size from headers or returns default

  ## Examples

    iex> conn = build_conn()
    iex> extract_page_size(conn, 10)
    10
    iex> conn = %{ conn | req_headers: [{ "x-page-size", "30" }] }
    iex> extract_page_size(conn)
    30
  """
  @spec extract_page_size(Plug.Conn.t, integer) :: integer
  def extract_page_size(conn, default \\ 25) do
    page = conn
    |> Conn.get_req_header("x-page-size")
    |> List.first
    if page, do: elem(Integer.parse(page), 0), else: default
  end

  @doc """
  Extracts offset from headers

  ## Examples

  iex> conn = build_conn()
  iex> extract_offset(conn)
  0
  iex> conn = %{ conn | req_headers: [{ "x-offset", "42" }] }
  iex> extract_offset(conn)
  42
  """
  @spec extract_offset(Plug.Conn.t) :: integer
  def extract_offset(conn) do
    page = conn
    |> Conn.get_req_header("x-offset")
    |> List.first
    if page, do: elem(Integer.parse(page), 0), else: 0
  end
end
