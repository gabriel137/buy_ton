defmodule BuyTon.ShoppingList.HandleShoppingList do
  @moduledoc """
    Esse módulo gerencia o processamento das listas de compras.

    Ele importa as funcionalidades de validação e cálculo de distribuição de compras de outros módulos no sistema.

    USO

    A função principal run/2 realiza o processamento das listas de compras e e-mails.
    Ela valida a integridade das listas, verifica a presença de e-mails duplicados e calcula a distribuição das compras entre os destinatários.
    Se todas as etapas forem bem-sucedidas, retorna um mapa contendo a distribuição das compras.
    Caso contrário, retorna uma tupla com informações sobre o erro encontrado.
  """
  alias BuyTon.Validations
  alias BuyTon.PurchaseCalculator


  @spec run(List.t, List.t) :: map | {:error, :duplicated_emails | :empty_lists | :invalid_total}
  def run(shopping_list, emails_list) do
    with {:ok, _} <- Validations.validate(shopping_list, emails_list),
         {:ok, purchase} <- PurchaseCalculator.splitting_account(shopping_list, emails_list) do
      purchase
    else
      {:error, reason} -> {:error, reason}
    end
  end

end
