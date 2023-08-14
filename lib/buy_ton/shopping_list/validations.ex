defmodule BuyTon.Validations do
  @moduledoc """
    Módulo contendo funções para calcular os valores de uma listas de compras distribuindo os valores por e-mails.

    Valida a lista de compras e a lista de e-mails.

    Realiza várias validações, incluindo verificação de listas vazias,
    detecção de e-mails duplicados e validação do valor total da compra.

    ## Parâmetros

    * `shopping_list` - A lista de itens de compra.
    * `emails_list` - A lista de endereços de e-mail.

    ## Retorno

    Retorna `{:ok, :valid_purchase}` se todas as validações forem bem-sucedidas.
    Retorna `{:error, reason}` se uma validação falhar, onde `reason` pode ser
    `:empty_lists`, `:duplicated_emails` ou `:invalid_total`.

  """
  @spec validate(shopping_list :: [map()], emails_list :: [String.t]) :: {:ok, :valid_purchase} | {:error, atom()}
  def validate(shopping_list, emails_list) do
    with {:ok, :non_empty_lists} <- has_empty_lists?(shopping_list, emails_list),
         {:ok, :unique_emails} <- has_duplicated_emails?(emails_list),
         {:ok, :valid_total} <- validate_total_value(calculate_total(shopping_list)) do
      {:ok, :valid_purchase}
    end
  end

  @spec calculate_total(shopping_list :: [map()]) :: number()
  def calculate_total(shopping_list) do
    shopping_list
    |> Enum.map(fn %{quantidade: qtd, preco_unidade: preco} -> qtd * preco end)
    |> Enum.sum()
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

  defp has_empty_lists?([], _), do: {:error, :empty_lists}
  defp has_empty_lists?(_, []), do: {:error, :empty_lists}
  defp has_empty_lists?(_, _), do: {:ok, :non_empty_lists}
end
