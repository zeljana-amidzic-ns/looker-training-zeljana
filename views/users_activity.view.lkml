view: users_activity {
  derived_table: {
    sql: SELECT users.id, users.first_name, users.last_name , ABS(DATE_DIFF(CAST(CURRENT_DATE() AS DATE), CAST(MAX(order_items.created_at) AS DATE), DAY)) AS days_difference
      FROM order_items LEFT JOIN users ON order_items.user_id = users.id
      GROUP BY users.first_name, users.last_name, users.id
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

  dimension: days_difference {
    type: number
    sql: ${TABLE}.days_difference ;;
  }

  set: detail {
    fields: [id, first_name, last_name, days_difference]
  }
}
