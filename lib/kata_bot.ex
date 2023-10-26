defmodule KataBot do
  use Nostrum.Consumer

  alias Nostrum.Api

  @impl true
  def handle_event({:READY, ready, _ws_state}) do
    command = %{
      name: "create kata",
      description: "Creates a Kata",
      options: [
        %{
          # ApplicationCommandType::STRING
          type: 3,
          name: "name",
          description: "name of the kata",
          required: true
        },
        %{
          # ApplicationCommandType::STRING
          type: 3,
          name: "question",
          description: "the question to ask",
          required: true,
        },
        %{
          # ApplicationCommandType::STRING
          type: 3,
          name: "restrictions",
          description: "restrictions on solving the problem",
          required: false,
        },
        %{
          # ApplicationCommandType::STRING
          type: 3,
          name: "optional_restrictions",
          description: "bonus restrictions to increase difficulty",
          required: false,
        },
        %{
          # ApplicationCommandType::STRING
          type: 3,
          name: "input",
          description: "the input the program should expect",
          required: true,
        },
        %{
          # ApplicationCommandType::STRING
          type: 3,
          name: "expected_output",
          description: "the expected output (solution) of the program",
          required: true,
        }
      ]
    }
    ready.guilds() |> Enum.each(&Nostrum.Api.create_guild_application_command(&1.id, command))
  end

  @impl true
  def handle_event({:INTERACTION_CREATE, interaction, _ws_sate}) do
    case interaction.name do
      "create" -> build_kata(interaction.options)
        |> KataBot.Commands.create_kata()
    end
  end

  @impl true
  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    IO.inspect msg
    case msg.content do
      "!list" ->
        case KataBot.Commands.list_kata() do
          {:ok, katas} -> kata_msg = katas |> format_kata_list()
            Api.create_message(msg.channel_id, kata_msg)
          _ -> Api.create_message(msg.channel_id, "Unable to fetch list.")
        end
      _ ->
        :ignore
    end
  end

  def build_kata(options) do
    Enum.reduce(options, %KataBot.Kata{}, &(
      &2 = case &1 do
        "name" -> %KataBot.Kata{&2 | name: &1.value}      
        "question" -> %KataBot.Kata{&2 | question: &1.value}      
        "restrictions" -> %KataBot.Kata{&2 | restrictions: &1.value}      
        "optional_restritions" -> %KataBot.Kata{&2 | optional_restrictions: &1.value}      
        "input" -> %KataBot.Kata{&2 | input: &1.value}      
        "expected_output" -> %KataBot.Kata{&2 | input: &1.value}      
      end
    ))
  end

  def format_kata_list(katas) do
    Enum.reduce(katas, "", &(
      &2 <> """
      - **id:** #{&1.id} **name:** #{&1.name}
      """
    ))
  end
end
