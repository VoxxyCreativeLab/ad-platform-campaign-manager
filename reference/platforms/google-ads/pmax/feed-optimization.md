---
title: PMax Feed Optimization (Google Merchant Center)
date: 2026-03-28
tags:
  - reference
  - google-ads
  - pmax
---

# PMax Feed Optimization (Google Merchant Center)

## Why Feed Quality Matters

For Shopping/PMax campaigns with a product feed, feed quality directly impacts:
- Which search queries trigger your products
- Ad relevance and Quality Score
- Click-through rate
- Conversion rate
- Impression share

## Essential Feed Attributes

### Required
| Attribute | Description | Tips |
|-----------|-------------|------|
| `id` | Unique product identifier | Consistent, never reused |
| `title` | Product name | Include brand, key features, color, size |
| `description` | Product description | Natural language, include keywords |
| `link` | Product page URL | Must be the canonical product URL |
| `image_link` | Main product image URL | White background, high quality |
| `price` | Product price | Include currency code |
| `availability` | In stock, out of stock, preorder | Keep synced with website |
| `brand` | Brand name | Or `identifier_exists = no` for unbranded |
| `condition` | New, refurbished, used | |
| `gtin` | Global Trade Item Number | EAN/UPC — highly recommended for matching |

### Strongly Recommended
| Attribute | Description | Tips |
|-----------|-------------|------|
| `additional_image_link` | Additional product images (up to 10) | Different angles, lifestyle shots |
| `sale_price` | Discounted price | Shows strikethrough pricing in ads |
| `product_type` | Your own product categorization | Up to 5 levels: `Apparel > Shoes > Running` |
| `google_product_category` | Google's taxonomy | Use most specific category available |
| `color` | Product color | Standardized color names |
| `size` | Product size | Use standard size formats |
| `custom_label_0` through `custom_label_4` | Custom grouping labels | Use for campaign segmentation |

## Title Optimization

Titles are the most important attribute for search matching and CTR.

### Formula
```
[Brand] + [Product Type] + [Key Feature] + [Color/Size/Variant]
```

### Examples
- Bad: "Running Shoe Model X"
- Good: "Nike Air Zoom Pegasus 41 Men's Running Shoe Black Size 10"
- Bad: "T-shirt"
- Good: "Patagonia P-6 Logo Organic Cotton T-Shirt Navy Blue Men's L"

### Rules
- Front-load important keywords (first 70 chars most visible)
- Max 150 characters (aim for 70-100)
- Don't use ALL CAPS or promotional text ("SALE!", "FREE SHIPPING")
- Include color, size, and material when relevant
- Match the title to what users actually search for

## Custom Labels for Campaign Segmentation

Custom labels let you group products for PMax asset group targeting:

| Label | Example Use | Values |
|-------|-------------|--------|
| `custom_label_0` | Margin tier | "high-margin", "low-margin" |
| `custom_label_1` | Seasonality | "summer", "winter", "year-round" |
| `custom_label_2` | Performance | "bestseller", "new", "clearance" |
| `custom_label_3` | Price range | "under-50", "50-100", "100-plus" |
| `custom_label_4` | Priority | "hero-product", "standard" |

Use these to create separate asset groups with different bid strategies:
- High-margin bestsellers → higher ROAS target
- Clearance items → lower ROAS target, maximize volume
- New products → maximize conversions (learning phase)

## Supplemental Feeds

Use supplemental feeds to override or add attributes without modifying the primary feed:

- Add custom labels without changing your e-commerce platform export
- Override titles for better ad performance
- Add `sale_price` for promotions
- Fix `google_product_category` mismatches

## Feed Health Checklist

- [ ] No disapproved products (check Merchant Center diagnostics)
- [ ] All required attributes populated
- [ ] GTINs provided where available
- [ ] Titles optimized with brand + product type + features
- [ ] High-quality images (min 100x100, recommended 800x800+)
- [ ] Prices match website (automatic price mismatch = disapproval)
- [ ] Availability matches website
- [ ] Feed updates at least daily
- [ ] Custom labels set for campaign segmentation
- [ ] No duplicate products
