defmodule KataBot do
  use Nostrum.Consumer

  require Logger
  alias Nostrum.Api
  alias Nostrum.Struct.Interaction

  @impl true
  def handle_event({:READY, ready, _ws_state}) do
    commands = [%{
      name: "create_kata",
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
        }
      ]
    },
    %{
      name: "rand_kata",
      description: "Get a random kata",
      options: []
    },
    %{
      name: "list_kata",
      description: "List all kata",
      options: []
    },
    %{
      name: "get_kata",
      description: "Get a specific kata",
      options: [
        %{
          type: 4,
          name: "kata_id",
          description: "id for kata to grab. get ids with /list_kata",
          required: true
        }
      ]
    },
    ]
    ready.guilds()
    |> Enum.each(fn guild -> 
        Logger.debug("Registering commands for guild #{guild.id}")
        Enum.each(commands, fn command -> 
          case Nostrum.Api.create_guild_application_command(guild.id, command) do
            {:error, err} -> Logger.error(err)
            _ -> Logger.debug("Registered #{command.name}, for #{guild.id}")
          end
        end)
    end)
  end

  @impl true
  def handle_event({:INTERACTION_CREATE, %Interaction{ data: %{name: "create_kata"}} = interaction, _ws_state}) do
    build_kata(interaction) |> KataBot.Commands.create_kata()
    response = %{
      type: 4,  # ChannelMessageWithSource
      data: %{
        content: "Created new kata!"
      }
    }
    Api.create_interaction_response(interaction, response)
  end

  @impl true
  def handle_event({:INTERACTION_CREATE, %Interaction{ data: %{name: "rand_kata"}} = interaction, _ws_state}) do
    case KataBot.Commands.rand_kata do
      {:ok, kata} -> kata_msg = kata |> format_single_kata()
        response = %{
          type: 4,  # ChannelMessageWithSource
          data: %{
            content: kata_msg
          }
        }
        Api.create_interaction_response(interaction, response)
    end
  end

  @impl true
  def handle_event({:INTERACTION_CREATE, %Interaction{ data: %{name: "list_kata"}} = interaction, _ws_state}) do
    case KataBot.Commands.list_kata do
      {:ok, katas} -> kata_msg = katas |> format_kata_list()
          response = %{
            type: 4,  # ChannelMessageWithSource
            data: %{
              content: kata_msg
            }
          }
          Api.create_interaction_response(interaction, response)
      _ -> Api.create_interaction_response(interaction, %{type: 4, data: %{content: "Unable to fetch list."}})
    end
  end

  @impl true
  def handle_event({:INTERACTION_CREATE, %Interaction{ data: %{name: "get_kata", options: options}} = interaction, _ws_state}) do
    [%{value: id}] = Enum.filter(options, &(&1.name == "kata_id"))
    case KataBot.Commands.get_kata(id) do
      {:ok, kata} -> kata_msg = kata |> format_single_kata
        response = %{
          type: 4,  # ChannelMessageWithSource
          data: %{
            content: kata_msg
          }
        }
        Api.create_interaction_response(interaction, response)
      {:error, msg} -> response = %{
          type: 4,  # ChannelMessageWithSource
          data: %{
            content: msg
          }
        }
        Api.create_interaction_response(interaction, response)
    end
  end

  def build_kata(%Interaction{data: %{options: options}}) do
    Enum.reduce(options, %KataBot.Kata{}, &(
      &2 = case &1.name do
        "name" -> %KataBot.Kata{&2 | name: &1.value}      
        "question" -> %KataBot.Kata{&2 | question: &1.value}      
        "restrictions" -> %KataBot.Kata{&2 | restrictions: &1.value}      
        "optional_restritions" -> %KataBot.Kata{&2 | optional_restrictions: &1.value}      
        "input" -> %KataBot.Kata{&2 | input: &1.value}      
        "expected_output" -> %KataBot.Kata{&2 | expected_output: &1.value}      
      end
    ))
  end

  def format_single_kata(kata) do
    """
    **#{kata.name}**
    **Question**
    > #{kata.question}
    **Restrictions**
    > #{kata.restrictions}
    **Optional Restrictions**
    > #{kata.optional_restrictions}
    **Input**
    > #{kata.input}
    **Expected Output**
    ||#{kata.expected_output}||
    """
  end

  def format_kata_list(katas) do
    Enum.reduce(katas, "", &(
      &2 <> """
      - **id:** #{&1.id} **name:** #{&1.name}
      """
    ))
  end
end
