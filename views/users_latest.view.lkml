view: users_latest {
  derived_table: {
    sql: SELECT users.id, users.first_name, ABS(DATE_DIFF(CAST(MAX(order_items.created_at) AS DATE), CURRENT_DATE(), DAY)) AS Latest
      FROM order_items LEFT JOIN users ON order_items.user_id = users.id
      GROUP BY users.first_name, users.id
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

  dimension: latest {
    type: number
    sql: ${TABLE}.Latest ;;
  }

  measure: average_latest_days {
    type: average
    sql: ${latest} ;;
  }

  set: detail {
    fields: [id, first_name, latest]
  }
}
