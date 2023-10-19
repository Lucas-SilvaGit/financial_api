module V1
  class DashboardController < ApplicationController
    def show
      year = params[:year].to_i
      month = params[:month].to_i

      # Formata o mês com dois dígitos
      formatted_month = format('%02d', month)

      # Consulta para calcular o total de RECEITAS no mês e ano especificados
      total_revenues = Entry.where(entry_type: 'revenue', billed: true)
                            .where("strftime('%Y', date) = ? AND strftime('%m', date) = ?", year.to_s, formatted_month)
                            .sum(:value)

      # Consulta para calcular o total de RECEITAS PREVISTO no mês e ano especificados
      total_revenues_expected = Entry.where(entry_type: 'revenue')
                                    .where("strftime('%Y', date) = ? AND strftime('%m', date) = ?", year.to_s, formatted_month)
                                    .sum(:value)

      # Consulta para calcular o total de DESPESAS no mês e ano especificados
      total_expenses = Entry.where(entry_type: 'expense', billed: true)
                            .where("strftime('%Y', date) = ? AND strftime('%m', date) = ?", year.to_s, formatted_month)
                            .sum(:value)

      # Consulta para calcular o total de DESPESAS PREVISTO no mês e ano especificados
      total_expenses_expected = Entry.where(entry_type: 'expense')
                                    .where("strftime('%Y', date) = ? AND strftime('%m', date) = ?", year.to_s, formatted_month)
                                    .sum(:value)

      # Calculo do SALDO TOTAL das contas no mês e ano especificados
      balance_total = total_revenues - total_expenses

      # Calculo do SALDO TOTAL das contas PREVISTO no mês e ano especificados
      balance_total_expected = total_revenues_expected - total_expenses_expected

      # Consulta para obter as 10 maiores entradas baseadas nos valores (ordem decrescente)
      top_entries_revenue = Entry.where(entry_type: 'revenue', billed: true)
                                  .where("strftime('%Y', date) = ? AND strftime('%m', date) = ?", year.to_s, formatted_month)
                                  .order('value DESC')
                                  .limit(5)
                                  .select(:description, :value, :date)
      
      top_entries_expense = Entry.where(entry_type: 'expense', billed: true)
                                  .where("strftime('%Y', date) = ? AND strftime('%m', date) = ?", year.to_s, formatted_month)
                                  .order('value DESC')
                                  .limit(5)
                                  .select(:description, :value, :date)

      # consulta para obter os saldos de cada conta.
      accounts = Account.where('balance > 0')
      account_balance = {}
    
      accounts.each do |account|
        account.calculate_balance
        account_balance[account.name] = account.balance
      end

      render json: {
        totalRevenues: total_revenues,
        totalRevenuesExpected: total_revenues_expected,
        totalExpenses: total_expenses,
        totalExpensesExpected: total_expenses_expected,
        balanceTotal: balance_total,
        balanceTotalExpected: balance_total_expected,
        topEntriesRevenues: top_entries_revenue,
        topEntriesExpenses: top_entries_expense,
        accountBalance: account_balance
      }
    end
  end
end
