include: "/views/input_data.view"

view: +input_data {
  derived_table: {
    sql:  SELECT
            cost_center.cost_center  AS cost_center,
            cost_center.cost_center_owner  AS cost_center_owner,
            (unified_cloud_billing.usage_start_date ) AS usage_start_date,
            COALESCE(SUM(( unified_cloud_billing.cost*200  ) ), 0) AS total_cost
          FROM `mw-alpha-cloud-cost-usage.cloud_cost_final.unified_cloud_billing_date_impute` AS unified_cloud_billing
          LEFT JOIN mw-alpha-cloud-cost-usage.cloud_cost_final.project  AS project ON unified_cloud_billing.project_key = project.project_key
          LEFT JOIN mw-alpha-cloud-cost-usage.cloud_cost_final.service  AS service ON unified_cloud_billing.service_key = service.service_key
          LEFT JOIN `mw-alpha-cloud-cost-usage.cloud_cost_final.cost_center`
          AS cost_center ON (CASE WHEN COALESCE(project.project_name,(CASE WHEN LENGTH(service.service_id) = 0 THEN 'SNS Project' ELSE service.service_id END)) = '<missing>'
          THEN 'SNS Project'
          ELSE COALESCE(project.project_name,(CASE WHEN LENGTH(service.service_id) = 0 THEN 'SNS Project' ELSE service.service_id END)) END) = cost_center.resource_and_projects
          GROUP BY
           1,2,3
    ;;
  }


  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${cost_center},${usage_start_date}) ;;
  }

  dimension: cost_center {
    type: string
    sql: ${TABLE}.cost_center ;;
  }

  dimension: cost_center_owner {
    type: string
    sql: ${TABLE}.cost_center_owner ;;
  }

  dimension: resource_and_projects {
    type: string
    sql: ${TABLE}.resource_and_projects ;;
  }

  dimension: usage_start_date {
    convert_tz: no
    type: date
    datatype: date
    sql: ${TABLE}.usage_start_date ;;
  }

  dimension: total_cost {
    type: number
    sql: ${TABLE}.total_cost ;;
  }

  measure: sum_of_cost {
    label: "Total Cost"
    type: sum
    sql: ${total_cost} ;;
    value_format_name: usd_0
  }

  measure: count {
    type: count
  }
}
