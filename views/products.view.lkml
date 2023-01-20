view: products {
  sql_table_name: `thelook.products`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: brand_filter {
    type: string
    sql: ${TABLE}.brand;;
    html: <a href="/explore/leticia_model_exercise/order_items?fields=products.brand,orders.count,order_items.total_revenue,
    order_items.total_profit,users.count&f[products.brand]={{filterable_value}}">{{value}}</a>;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: category_with_dashboard {
    type: string
    sql: ${TABLE}.category ;;
    html: <a href="/dashboards/56">{{value}}</a> ;;
  }

  dimension: category_example {
    type: string
    sql: ${TABLE}.category ;;
    html: <a href="https://www.google.com/">{{value}}</a> ;;
  }

  dimension: category_example_dynamic {
    type: string
    sql: ${TABLE}.category ;;
    html: <a href="https://www.google.com/search?q={{value}}">{{value}}</a> ;;
  }

  dimension: category_with_link {
    type: string
    sql: ${TABLE}.category ;;
    link: {
      label: "Google Search"
      url: "https://www.google.com/search?q={{value}}"
      icon_url: "https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_L
ogo.svg"
    }
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_profit_condition {
    type: number
    sql: ${retail_price}  ;;
    value_format_name: usd
    html: {%if value >=100%}<font color="green">{{rendered_value}}</font>
          {%elsif value < 1000 and value >= 50%}<font color="gold">{{rendered_value}}</font>
          {%else%}<font color="red">{{rendered_value}}</font>{%endif%};;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      name,
      distribution_centers.name,
      distribution_centers.id,
      order_items.count,
      inventory_items.count
    ]
  }
}
