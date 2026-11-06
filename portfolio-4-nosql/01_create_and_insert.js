// JANTORA | Portfolio 4 | 01_create_and_insert.js
// Run in mongosh connected to your Atlas cluster, NOT in the Atlas Filter box.
// Same sample data as 01_insert_documents.json; use EITHER Atlas JSON insertion
// OR this script. Do not do both unless you intend to reconcile duplicates.

const jantora = db.getSiblingDB("jantora_nosql");
const products = jantora.getCollection("products");
const sample = [
  {
    "product_id": 1,
    "product_name": "Rice",
    "category": "Foodstuff",
    "price": 45000,
    "currency": "NGN",
    "attributes": {
      "brand": "Jantora Select",
      "weight": "50kg",
      "packaging": "Bag"
    },
    "stock_by_branch": [
      {
        "branch": "Ikeja",
        "quantity": 30
      },
      {
        "branch": "Lekki",
        "quantity": 15
      }
    ]
  },
  {
    "product_id": 2,
    "product_name": "Cooking Oil",
    "category": "Foodstuff",
    "price": 12500,
    "currency": "NGN",
    "attributes": {
      "brand": "Jantora Select",
      "volume": "5L",
      "packaging": "Bottle"
    },
    "stock_by_branch": [
      {
        "branch": "Ikeja",
        "quantity": 20
      },
      {
        "branch": "Lekki",
        "quantity": 12
      }
    ]
  },
  {
    "product_id": 3,
    "product_name": "Laundry Detergent",
    "category": "Household",
    "price": 6500,
    "currency": "NGN",
    "attributes": {
      "weight": "2kg",
      "form": "Powder",
      "scent": "Fresh"
    },
    "stock_by_branch": [
      {
        "branch": "Ikeja",
        "quantity": 25
      },
      {
        "branch": "Lekki",
        "quantity": 10
      }
    ]
  },
  {
    "product_id": 4,
    "product_name": "Electric Kettle",
    "category": "Appliances",
    "price": 18000,
    "currency": "NGN",
    "attributes": {
      "capacity": "1.8L",
      "power": "1500W",
      "warranty_months": 12
    },
    "stock_by_branch": [
      {
        "branch": "Ikeja",
        "quantity": 8
      },
      {
        "branch": "Lekki",
        "quantity": 5
      }
    ]
  }
];
for (const product of sample) {
  const result = products.updateOne(
    { product_id: product.product_id },
    { $setOnInsert: product },
    { upsert: true }
  );
  print(`Product ${product.product_id}: inserted=${result.upsertedCount}, matched=${result.matchedCount}`);
}
print(`Sample product IDs 1-4 present: ${products.countDocuments({ product_id: { $in: [1,2,3,4] } })}`);
products.find({ product_id: { $in: [1,2,3,4] } }).sort({ product_id: 1 }).forEach(printjson);
