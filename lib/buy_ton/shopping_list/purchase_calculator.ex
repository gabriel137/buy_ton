defmodule BuyTon.PurchaseCalculator do
  import BuyTon.Validations

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
