view: order_items {
  sql_table_name: `thelook.order_items`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension_group: delivered {
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
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: date_example {
    type: date
    sql: ${TABLE}.returned_at ;;
    html: {{rendered_value | date: "%B %e, %Y"}} ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
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
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    case: {
      when: {
        sql: (SELECT COUNT(${order_id}) FROM ${TABLE}) = 1 ;;
        label: "1 Order"
      }
      when: {
        sql: (SELECT COUNT(${order_id}) FROM ${TABLE}) = 2 ;;
        label: "2 Orders"
      }
      when: {
        sql: (SELECT COUNT(${order_id}) FROM ${TABLE}) > 2 AND (SELECT COUNT(${order_id}) FROM ${TABLE}) < 6 ;;
        label: "3-5 Orders"
      }
      when: {
        sql: (SELECT COUNT(${order_id}) FROM ${TABLE}) > 5 AND (SELECT COUNT(${order_id}) FROM ${TABLE}) < 10 ;;
        label: "6-9 Orders"
      }
      when: {
        sql: (SELECT COUNT(${order_id}) FROM ${TABLE}) > 10 ;;
        label: "10+ Orders"
      }
      else: "0 Orders"
    }
  }

  dimension: customer_lifetime_revenue {
    case: {
      when: {
       sql: (SELECT SUM(${sale_price}) FROM ${TABLE}) >= 0 AND (SELECT SUM(${sale_price}) FROM ${TABLE}) < 5;;
       label: "$0.00 - $4.99"
      }
      when: {
        sql: (SELECT SUM(${sale_price}) FROM ${TABLE}) >= 5 AND (SELECT SUM(${sale_price}) FROM ${TABLE}) < 20;;
        label: "$5.00 - $19.99"
      }
      when: {
        sql: (SELECT SUM(${sale_price}) FROM ${TABLE}) >= 20 AND (SELECT SUM(${sale_price}) FROM ${TABLE}) < 50 ;;
        label: "$20.00 - $49.99"
      }
      when: {
        sql: (SELECT SUM(${sale_price}) FROM ${TABLE}) >= 50 AND (SELECT SUM(${sale_price}) FROM ${TABLE}) < 100 ;;
        label: "$50.00 - $99.99"
      }
      when: {
        sql: (SELECT SUM(${sale_price}) FROM ${TABLE}) >= 100 AND (SELECT SUM(${sale_price}) FROM ${TABLE}) < 500 ;;
        label: "$100.00 - $499.99"
      }
      when: {
        sql: (SELECT SUM(${sale_price}) FROM ${TABLE}) >= 500 AND (SELECT SUM(${sale_price}) FROM ${TABLE}) < 1000 ;;
        label: "$500.00 - $999.99"
      }
      else: "$1000.00 +"
    }
  }

  dimension: is_active {
    case: {
      when: {
        sql: (SELECT DATE_DIFF(CURRENT_DATE(),MAX(${TABLE}.created_at), DAY) FROM ${TABLE}) < 90;;
        label: "Active"
      }
      else: "Inactive"
    }
  }

  measure: customer_first_order {
    type: date
    sql: (SELECT MIN(${TABLE}.created_at) FROM ${TABLE}) ;;
    drill_fields: [user_id]
    html: {{rendered_value | date: "%B %e, %Y"}} ;;
  }

  measure: customer_latest_order {
    type: date
    sql: (SELECT MAX(${TABLE}.created_at) FROM ${TABLE}) ;;
    drill_fields: [user_id]
    html: {{rendered_value | date: "%B %e, %Y"}} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    drill_fields: [detail*]
    value_format_name: usd_0
  }

  measure: order_item_count {
    type: count
    drill_fields: [detail*]
  }

  measure: order_count {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_revenue {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_revenue_from_completed_orders {
    type: sum
    sql: ${sale_price} ;;
    filters: [status: "Complete"]
    value_format_name: usd
  }

  measure: customer_lifetime_orders {
    type: count
    drill_fields: [order_id]
  }

  measure: total_lifetime_orders {
    type: sum
    sql: ${order_id} ;;
  }

  measure: average_lifetime_orders {
    type: average
    sql: ${order_id} ;;
  }

  # TODO: redo this one
  measure: average_lifetime_revenue {
    type: average
    sql: (SELECT SUM(${sale_price}) FROM ${TABLE}) ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name,
      products.name,
      products.id
    ]
  }
}
