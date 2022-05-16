connection: "@{database_connection}"

include: "/explores/bqml_arima.explore"
include: "/use_case_refinements/cost_management_forecast/*"


explore: cost_management_forecast {
  label: "BQML ARIMA Plus: Cost Management Forecast"
  description: "Use this Explore to create BQML ARIMA Plus models to forecast various metrics using Looker's Cost Management dataset"
  hidden: yes
  extends: [bqml_arima]

  join: arima_forecast {
    type: full_outer
    relationship: one_to_one
    sql_on: ${input_data.usage_start_date} = ${arima_forecast.forecast_date} AND ${input_data.cost_center} = ${arima_forecast.cost_center} ;;
  }

  join: arima_explain_forecast {
    type: full_outer
    sql_on: ${arima_forecast.forecast_raw} = ${arima_explain_forecast.time_series_raw} AND ${arima_forecast.cost_center} = ${arima_explain_forecast.cost_center} ;;
    relationship: one_to_one
  }
}
