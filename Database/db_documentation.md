# Database Documentation

## Overview

The database is designed for an e-commerce platform and follows a relational model using PostgreSQL.

The schema is organized into five main domains:

* Catalog
* Product Variants
* Customers
* Shopping Cart
* Orders and Fulfillment

---

# Entity Relationship Overview

```text
Categories
    │
    └── ProductCategories
            │
            └── Products
                    │
                    ├── Variants
                    │      └── VariantOptions
                    │
                    └── ProductImages

Users
    │
    └── Customers
            │
            ├── Addresses
            ├── Carts
            │      └── CartItems
            │
            └── Orders
                   ├── OrderItems
                   ├── Payments
                   └── Shipments
```

---

# Catalog

## Categories

Stores the product category hierarchy.

| Column     | Description             |
| ---------- | ----------------------- |
| id         | Primary key             |
| name       | Category name           |
| slug       | SEO-friendly identifier |
| image_path | Image ubication         |
| parent_id  | Parent category         |

Features:

* Supports unlimited nesting.
* Self-referencing relationship.
* Indexed by `parent_id`.

Example:

```text
Electronics
├── Computers
│   ├── Laptops
│   └── Desktops
└── Smartphones
```

---

## Products

Stores the generic product information.

| Column      | Description           |
| ----------- | --------------------- |
| id          | Primary key           |
| name        | Product name          |
| slug        | SEO-friendly URL      |
| code        | Internal product code |
| description | Product description   |
| active      | Product visibility    |
| created_at  | Creation timestamp    |

A product represents a commercial item but does not contain price or inventory information directly.

---

## Product Categories

Many-to-many relationship between products and categories.

Allows a product to belong to multiple categories.

Example:

```text
Gaming Laptop
├── Laptops
├── Computers
└── Gaming
```

---

# Product Variants

## Variants

Represents purchasable product versions.

| Column     | Description               |
| ---------- | ------------------------- |
| id         | Primary key               |
| product_id | Product reference         |
| sku        | Unique stock keeping unit |
| name       | Variant name              |
| price      | Variant price             |
| active     | Availability              |
| created_at | Creation timestamp        |

Examples:

```text
T-Shirt
├── Small
├── Medium
└── Large
```

```text
iPhone
├── 128 GB
├── 256 GB
└── 512 GB
```

Each variant can have its own:

* Price
* Inventory
* SKU
* Availability

---

## Option Types

Defines available variant attributes.

Examples:

| Name    | Code    |
| ------- | ------- |
| Color   | color   |
| Size    | size    |
| Storage | storage |

The `sort_order` field controls display ordering.

---

## Variant Options

Stores the selected value for a variant attribute.

Example:

```text
Variant
├── Color = Black
└── Size = XL
```

Unique constraint:

```text
(variant_id, option_type_id)
```

A variant can only have one value for each option type.

---

## Product Images

Stores product images.

| Column     | Description       |
| ---------- | ----------------- |
| id         | Primary key       |
| product_id | Product reference |
| path       | Image ubication   |
| sort_order | Display order     |

A product may contain multiple images.

---

# User Management

## Users

Authentication and authorization records.

| Column         | Description                 |
| -------------- | --------------------------- |
| id             | Primary key                 |
| email          | Login email                 |
| password_hash  | Hashed password             |
| role           | User role                   |
| last_token_jti | Active JWT session identifier |
| created_at     | Creation timestamp          |

Possible roles:

```text
admin
customer
```

Additional roles can be added later.

---

## Customers

Customer profile information.

| Column     | Description        |
| ---------- | ------------------ |
| id         | Primary key        |
| user_id    | User reference     |
| first_name | First name         |
| last_name  | Last name          |
| phone      | Contact phone      |
| created_at | Creation timestamp |

Relationship:

```text
User 1 ─── 1 Customer
```

---

## Addresses

Customer addresses.

| Column      | Description        |
| ----------- | ------------------ |
| id          | Primary key        |
| customer_id | Customer reference |
| street      | Street address     |
| city        | City               |
| province    | Province           |
| postal_code | Postal code        |
| country     | Country            |
| is_default  | Default address    |

A customer can have multiple saved addresses.

---

# Shopping Cart

## Carts

Stores shopping carts.

| Column      | Description        |
| ----------- | ------------------ |
| id          | Primary key        |
| customer_id | Customer reference |
| created_at  | Creation timestamp |
| status      | Cart status        |

Suggested statuses:

```text
active
abandoned
converted
```

---

## Cart Items

Stores products inside a cart.

| Column     | Description     |
| ---------- | --------------- |
| id         | Primary key     |
| cart_id    | Cart reference  |
| variant_id | Product variant |
| quantity   | Quantity        |

Unique constraint:

```text
(cart_id, variant_id)
```

The same variant cannot appear twice in the same cart.

---

# Orders

## Orders

Represents completed purchases.

| Column       | Description        |
| ------------ | ------------------ |
| id           | Primary key        |
| customer_id  | Customer reference |
| status       | Order status       |
| total_amount | Final amount       |
| created_at   | Creation timestamp |

Suggested statuses:

```text
pending
paid
processing
shipped
completed
cancelled
refunded
```

---

## Order Items

Snapshot of purchased products.

| Column           | Description              |
| ---------------- | ------------------------ |
| id               | Primary key              |
| order_id         | Order reference          |
| variant_id       | Variant reference        |
| quantity         | Quantity                 |
| unit_price       | Purchase price           |
| product_name     | Product snapshot         |
| variant_name     | Variant snapshot         |
| sku              | SKU snapshot             |
| options_snapshot | Variant options snapshot |

This table intentionally duplicates product information.

Reason:

Products may change after purchase, while order history must remain immutable.

---

# Payments

## Payments

Stores payment transactions.

| Column         | Description                     |
| -------------- | ------------------------------- |
| id             | Primary key                     |
| order_id       | Order reference                 |
| method         | Payment method                  |
| status         | Payment status                  |
| transaction_id | External transaction identifier |
| amount         | Paid amount                     |
| created_at     | Creation timestamp              |

Suggested methods:

```text
mercadopago
credit_card
debit_card
bank_transfer
cash
```

Suggested statuses:

```text
pending
approved
rejected
cancelled
refunded
```

---

# Shipping

## Shipments

Stores shipment information.

| Column               | Description          |
| -------------------- | -------------------- |
| id                   | Primary key          |
| order_id             | Order reference      |
| cost                 | Shipping cost        |
| status               | Shipment status      |
| shipping_street      | Delivery address     |
| shipping_city        | Delivery city        |
| shipping_province    | Delivery province    |
| shipping_postal_code | Delivery postal code |

Suggested statuses:

```text
pending
ready
shipped
in_transit
delivered
returned
```

The shipping address is duplicated intentionally to preserve historical data.

---

# Design Decisions

## Product / Variant Separation

Products contain marketing information.

Variants contain commercial information.

Example:

```text
Product
└── Running Shoes

Variants
├── Size 40
├── Size 41
├── Size 42
└── Size 43
```

This avoids duplicating descriptions, images, and categories.

---

## Order Snapshots

Order items store product information redundantly.

This guarantees that historical orders remain unchanged even if:

* Product names change.
* Prices change.
* SKUs change.
* Variant options change.

---

## Category Hierarchy

Categories use a self-referencing structure.

Benefits:

* Unlimited nesting depth.
* Flexible navigation menus.
* Efficient catalog organization.

---

## Future Extensions

The schema can be expanded with:

* Inventory management
* Warehouses
* Coupons and promotions
* Product reviews
* Wishlists
* Audit logs
* Tax rules
* Multi-currency pricing
* Multi-vendor support
* Product brands
