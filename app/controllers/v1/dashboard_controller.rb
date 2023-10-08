module V1
  class DashboardController < ApplicationController
    def show
      year = params[:year].to_i
      month = params[:month].to_i

      # Formata o mês com dois dígitos
      formatted_month = format('%02d', month)

      # Consulta para calcular o total de receitas no mês e ano especificados
      total_revenue = Entry.where(entry_type: 'revenue', billed: true)
                           .where("strftime('%Y', date) = ? AND strftime('%m', date) = ?", year.to_s, formatted_month)
                           .sum(:value)

      # Consulta para calcular o total de receitas previsto no mês e ano especificados
      total_revenue_expected = Entry.where(entry_type: 'revenue')
                                    .where("strftime('%Y', date) = ? AND strftime('%m', date) = ?", year.to_s, formatted_month)
                                    .sum(:value)

      # Consulta para calcular o total de despesas no mês e ano especificados
      total_expenses = Entry.where(entry_type: 'expense', billed: true)
                            .where("strftime('%Y', date) = ? AND strftime('%m', date) = ?", year.to_s, formatted_month)
                            .sum(:value)

      # Calculo do saldo total das contas no mês e ano especificados
      balance_total = total_revenue - total_expenses

      render json: {
        totalRevenues: total_revenue,
        totalRevenuesExpected: total_revenue_expected,
        totalExpenses: total_expenses,
        balanceTotal: balance_total
      }
    end
  end
end
