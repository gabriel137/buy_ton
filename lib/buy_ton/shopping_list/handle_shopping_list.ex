defmodule BuyTon.ShoppingList.HandleShoppingList do
  import BuyTon.Validations
  import BuyTon.PurchaseCalculator


  def run(shopping_list, emails_list) do
    with {:ok, _} <- validate(shopping_list, emails_list),
         {:ok, purchase} <- splitting_account(shopping_list, emails_list) do
      purchase
    end
  end

end
