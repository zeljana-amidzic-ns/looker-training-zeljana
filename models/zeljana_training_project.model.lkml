connection: "looker_partner_demo"

# include all the views
include: "/views/**/*.view"

datagroup: zeljana_training_project_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: zeljana_training_project_default_datagroup

explore: users {
  view_name: users

  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: one_to_many
  }

  join: users_latest {
    type: left_outer
    sql_on: ${users.id} = ${users_latest.id} ;;
    relationship: many_to_one
  }

  join: users_activity {
    type: left_outer
    sql_on: ${users.id} = ${users_activity.id} ;;
    relationship: many_to_one
  }

  join: users_revenue {
    type: left_outer
    sql: ${users.id} = ${users_revenue.id} ;;
    relationship: many_to_one
  }
}

explore: users_extended {
  extends: [users]
}

explore: distribution_centers {}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: users_latest {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users_latest.id} ;;
    relationship: many_to_one
  }

  join: users_activity {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users_activity.id} ;;
    relationship: many_to_one
  }

  join: users_revenue {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users_revenue.id} ;;
    relationship: many_to_one
  }
  #sql_always_having: ${sale_price} > 200 ;;
  #sql_always_where: (${returned_date} IS NOT NULL) and (${sale_price} > 200) ;;

}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}
