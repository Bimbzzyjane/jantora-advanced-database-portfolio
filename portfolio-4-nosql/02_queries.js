// JANTORA | Portfolio 4 | 02_queries.js
// Database: jantora_nosql
// Collection: products
// MongoDB Shell commands with equivalent Atlas Data Explorer filters.

const jantora = db.getSiblingDB("jantora_nosql");
const products = jantora.getCollection("products");

// Q1: Retrieve Foodstuff products.
// Atlas Filter: { "category": "Foodstuff" }
print("Q1: Foodstuff products");
products.find({ category: "Foodstuff" }).forEach(printjson);

// Q2: Find products priced above NGN 15,000.
// Atlas Filter: { "price": { "$gt": 15000 } }
print("Q2: Products priced above NGN 15000");
products.find({ price: { $gt: 15000 } }).forEach(printjson);

// Q3: Find products that have a weight attribute.
// Atlas Filter: { "attributes.weight": { "$exists": true } }
print("Q3: Products with a weight attribute");
products.find({ "attributes.weight": { $exists: true } }).forEach(printjson);

// Q4: Find products with fewer than 10 units in Ikeja.
// Atlas Filter:
// { "stock_by_branch": {
//     "$elemMatch": {
//       "branch": "Ikeja",
//       "quantity": { "$lt": 10 }
//     }
//   }
// }
print("Q4: Products with Ikeja stock below 10 units");
products.find({
  stock_by_branch: {
    $elemMatch: {
      branch: "Ikeja",
      quantity: { $lt: 10 }
    }
  }
}).forEach(printjson);
