defmodule KataBotTest do
  use ExUnit.Case
  doctest KataBot

  test "parses command into %KataBot.Kata{} struct" do
    assert %Nostrum.Struct.Interaction{
      data: %Nostrum.Struct.ApplicationCommandInteractionData{
        id: 3333333333333333333,
        name: "create_kata",
        resolved: nil,
        options: [
          %Nostrum.Struct.ApplicationCommandInteractionDataOption{
            name: "name",
            type: 3,
            value: "Sort",
            options: nil,
            focused: nil
          }, 
          %Nostrum.Struct.ApplicationCommandInteractionDataOption{
            name: "question",
            type: 3,
            value: "Can you sort this list?",
            options: nil,
            focused: nil
          },
          %Nostrum.Struct.ApplicationCommandInteractionDataOption{
            name: "input",
            type: 3, 
            value: "[3,1,2]",
            options: nil,
            focused: nil
          },
          %Nostrum.Struct.ApplicationCommandInteractionDataOption{
            name: "expected_output",
            type: 3,
            value: "[1,2,3]",
            options: nil,
            focused: nil
          }
        ],
      }
    }
    |> KataBot.build_kata() == %KataBot.Kata{
      name: "Sort",
      question: "Can you sort this list?",
      input: "[3,1,2]",
      expected_output: "[1,2,3]"
    }
  end

  test "formats kata list correctly" do

  assert [
    %KataBot.Kata{
      id: 1,
      name: "Foo",
    },
    %KataBot.Kata{
      id: 2,
      name: "Bar",
    }
  ] |> KataBot.format_kata_list() == "- **id:** 1 **name:** Foo\n- **id:** 2 **name:** Bar\n"

  end

  test "formats a single kata to a discord message output" do
   assert  %KataBot.Kata{
      name: "Sort",
      question: "Can you sort this list?",
      restrictions: "None",
      optional_restrictions: "None",
      input: "[3,1,2]",
      expected_output: "[1,2,3]"
    } |> KataBot.format_single_kata ==  """
    **Sort**
    **Question**
    > Can you sort this list?
    **Restrictions**
    > None
    **Optional Restrictions**
    > None
    **Input**
    > [3,1,2]
    **Expected Output**
    ||[1,2,3]||
    """
  end
  test "handles unexpected event without failing" do
    assert KataBot.handle_event({:something_random}) == :noop
  end
end
