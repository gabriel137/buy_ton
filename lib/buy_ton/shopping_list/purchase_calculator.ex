defmodule BuyTon.PurchaseCalculator do
  @moduledoc """
    Este módulo fornece funções para calcular a distribuição das compras.

    A função principal splitting_account/2 recebe uma lista de itens de compra e uma lista de e-mails, e calcula a distribuição dos valores
    com base no valor total da lista de compras.
    Os valores são distribuídos da maneira mais uniforme possível entre os e-mails, garantindo que nenhum valor seja perdido.

    ## Usage

    Para calcular a distribuição de valores, chame a função splitting_account/2 com a lista de compras e a lista de e-mails.

    ```
      shopping_list = [
        %{item: "item1", quantidade: 2, preco_unidade: 300},
        %{item: "item2", quantidade: 1, preco_unidade: 150}
      ]

      emails_list = ["user1@example.com", "user2@example.com", "user3@example.com"]

      {:ok, purchase_distribution} = BuyTon.PurchaseCalculator.splitting_account(shopping_list, emails_list)
    ```

  """
  import BuyTon.Validations

  @spec splitting_account(List.t, List.t) :: {:ok, map}
  def splitting_account(shopping_list, emails_list) do
    total_value_purchase = calculate_total(shopping_list)
    email_count = length(emails_list)

    split_purchase =
      total_value_purchase / email_count
      |> floor()

    cents_to_compensate = total_value_purchase - (split_purchase * email_count)
    adjusted_emails = distribute_cents(emails_list, cents_to_compensate, split_purchase)

    purchase =
      Enum.zip(emails_list, adjusted_emails)
      |> Map.new()

    {:ok, purchase}
  end


  defp distribute_cents(emails, cents_to_compensate, split_purchase) do
    distribute_cents_rec(emails, abs(cents_to_compensate), split_purchase, [])
  end

  defp distribute_cents_rec([], _, _, acc), do: Enum.reverse(acc)

  defp distribute_cents_rec([_email | tail], cents_to_compensate, split_purchase, acc) do
    if cents_to_compensate > 0 do
      distribute_cents_rec(tail, cents_to_compensate - 1, split_purchase, [split_purchase + 1 | acc])
    else
      distribute_cents_rec(tail, cents_to_compensate, split_purchase, [split_purchase | acc])
    end
  end

end
