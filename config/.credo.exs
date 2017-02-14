%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "src/", "web/", "apps/"],
        excluded: [~r"/_build/", ~r"/deps/"]
      },
      check_for_updates: true,
      strict: false,
      color: true,
      checks: [
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 120},
      ]
    }
  ]
}
