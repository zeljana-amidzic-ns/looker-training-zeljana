view: inventory_items {
  sql_table_name: `thelook.inventory_items`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.sold_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, product_name, products.name, products.id, order_items.count]
  }

  measure: count_products {
    type: count
    drill_fields: [id, products.id]
  }

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
  }

  measure: sum_retail {
    type: sum
    sql: ${product_retail_price} ;;
  }

  measure: total_revenue {
    type: number
    sql: ${count}*${sum_retail};;
  }

  measure: total_revenue_example {
    type: number
    sql: ${count}*${sum_retail};;
    value_format_name: usd
    html: {{rendered_value | replace:',',' ' | replace: '.',','}} ;;
  }

  measure: total_profit_example {
    type: number
    sql: ${total_revenue}-${total_cost} ;;
    value_format_name: usd
    html: <font color="green">{{rendered_value}}</font> ;;
  }

  measure: total_profit_condition {
    type: number
    sql: ${total_revenue}-${inventory_items.total_cost}  ;;
    value_format_name: usd
    html: {%if value >=75000 %}<font color="green">{{rendered_value}}</font>
          {%elsif value < 75000 and value >= 50000%}<font color="gold">{{rendered_value}}</font>
          {%else%}<font color="red">{{rendered_value}}</font>{%endif%};;
  }

  measure: count_test {
    type: count
    drill_fields: [products.category, total_profit_example]
    html: <a href="{{link}}&f[order_items.total_profit]=>50000">{{rendered_value}}</a> ;;
  }

  measure: count_test_link {
    type: count
    drill_fields: [products.category, total_profit_example]
    link: {
      label: "Filtered Drill Model"
      url: "{{link}}&f[total_profit_example]=>=50000"
    }
  }
}
