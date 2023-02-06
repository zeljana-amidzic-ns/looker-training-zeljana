view: users_revenue {
  derived_table: {
    sql: SELECT users.id, users.first_name, users.last_name, SUM(order_items.sale_price) as revenue, COUNT(order_items.order_id) as lifetime
      FROM order_items LEFT JOIN users on order_items.user_id = users.id
      GROUP BY users.id, users.first_name, users.last_name
       ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}.revenue ;;
  }

  dimension: lifetime {
    type: number
    sql: ${TABLE}.lifetime ;;
  }

  set: detail {
    fields: [id, first_name, last_name, revenue]
  }
}
