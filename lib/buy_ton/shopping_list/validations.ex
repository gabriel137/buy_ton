defmodule BuyTon.Validations do

  def validate(shopping_list, emails_list) do
    with {:ok, :non_empty_lists} <- has_empty_lists?(shopping_list, emails_list),
        {:ok, :unique_emails} <- has_duplicated_emails?(emails_list),
        {:ok, :valid_total} <- validate_total_value(calculate_total(shopping_list)) do
      {:ok, :valid_purchase}
    end
  end

  def calculate_total(shopping_list) do
    shopping_list
    |> Enum.map(fn %{quantidade: qtd, preco_unidade: preco} -> qtd * preco end)
    |> Enum.sum
  end

  defp validate_total_value(value_total) when value_total < 0, do: {:error, :invalid_total}

  defp validate_total_value(_value_total), do: {:ok, :valid_total}

  defp has_duplicated_emails?(emails_list) do
    unique_emails = Enum.uniq(emails_list)

    case unique_emails == emails_list do
      true -> {:ok, :unique_emails}
      false -> {:error, :duplicated_emails}
    end
  end

  defp has_empty_lists?(shopping_list, emails_list) do
    case {shopping_list, emails_list} do
      {[], []} ->
        {:error, :empty_lists}

      _ -> {:ok, :non_empty_lists}
    end
  end
end
