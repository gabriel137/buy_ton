defmodule BuyTon.ShoppingListTest do
  use ExUnit.Case

  alias BuyTon.ShoppingList.HandleShoppingList

  setup do
    shopping_list = [
      %{item: "computador", quantidade: 1, preco_unidade: 300},
      %{item: "mouse", quantidade: 1, preco_unidade: 300},
      %{item: "teclado", quantidade: 1, preco_unidade: 400}
    ]

    emails_list = [
      "teste1@test.com",
      "teste2@test.com",
      "teste3@test.com"
    ]

    %{shopping_list: shopping_list, emails_list: emails_list}
  end

  describe "handling data validations exceptions" do
    test "check duplicated emails", %{shopping_list: shopping_list} do
      duplicated_emails = ["teste1@test.com", "teste1@test.com"]
      assert {:error, :duplicated_emails} = HandleShoppingList.run(shopping_list, duplicated_emails)
    end

    test "check empty lists" do
      shopping_list = []
      emails_list = []

      assert {:error, :empty_lists} = HandleShoppingList.run(shopping_list, emails_list)
    end

    test "check is valid total", %{emails_list: emails_list} do
      shopping_list = [
        %{item: "computador", quantidade: -2, preco_unidade: 1.5},
        %{item: "mouse", quantidade: 3, preco_unidade: -0.8}
      ]

      assert {:error, :invalid_total} = HandleShoppingList.run(shopping_list, emails_list)
    end

  end

  describe "handling calculate purchases success" do
    test "check successful purchase split with 10 reais between 3 persons", %{shopping_list: shopping_list, emails_list: emails_list} do
      expected_purchases = %{
        "teste1@test.com" => 334,
        "teste2@test.com" => 333,
        "teste3@test.com" => 333
      }

      actual_purchases = HandleShoppingList.run(shopping_list, emails_list)

      assert expected_purchases == actual_purchases
    end

    test "check successful purchase split with 1.02 reais between 4 persons", %{emails_list: emails_list} do
      shopping_list = [
        %{item: "computador", quantidade: 1, preco_unidade: 52},
        %{item: "mouse", quantidade: 2, preco_unidade: 10},
        %{item: "teclado", quantidade: 1, preco_unidade: 10},
        %{item: "ssd", quantidade: 1, preco_unidade: 10},
        %{item: "headphone", quantidade: 1, preco_unidade: 10}
      ]

      emails_list = List.insert_at(emails_list, -1, "teste4@test.com")

      expected_purchases = %{
        "teste1@test.com" => 26,
        "teste2@test.com" => 26,
        "teste3@test.com" => 25,
        "teste4@test.com" => 25
      }

      actual_purchases = HandleShoppingList.run(shopping_list, emails_list)

      assert expected_purchases == actual_purchases
    end

    test "check successful purchase split with 1 centavo between 3 persons", %{emails_list: emails_list} do
      shopping_list = [
        %{item: "computador", quantidade: 2, preco_unidade: 5}
      ]

      expected_purchases = %{
        "teste1@test.com" => 4,
        "teste2@test.com" => 3,
        "teste3@test.com" => 3,
      }

      actual_purchases = HandleShoppingList.run(shopping_list, emails_list)

      assert expected_purchases == actual_purchases
    end
  end
end
