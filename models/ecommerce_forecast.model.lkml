connection: "@{database_connection}"

include: "/explores/bqml_arima.explore"
include: "/use_case_refinements/ecommerce_forecast/*"


explore: ecommerce_forecast {
  label: "BQML ARIMA Plus: eCommerce Forecast"
  description: "Use this Explore to create BQML ARIMA Plus models to forecast various metrics using Looker's eCommerce dataset"
  hidden: yes
  extends: [bqml_arima]

  join: arima_forecast {
    type: full_outer
    relationship: one_to_one
    sql_on: ${input_data.created_date} = ${arima_forecast.forecast_date} ;;
  }
}
