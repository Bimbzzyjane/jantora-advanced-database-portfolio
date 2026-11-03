
 // JANTORA | Portfolio 4 | 03_update_and_delete.js
 // Database: jantora_nosql
 // Collection: products
 // Run each section separately in MongoDB Shell (mongosh).
 // Atlas Data Explorer equivalents are provided as comments.

 const jantora = db.getSiblingDB("jantora_nosql");
 const products = jantora.getCollection("products");

 // SECTION A: UPDATE ELECTRIC KETTLE WARRANTY (12 -> 18 MONTHS)
 // Atlas Filter: { "product_id": 4 }
 // Change attributes.warranty_months from 12 to 18. Screenshot: 07-update-result.png

 print("Before update:");
 printjson(products.findOne({ product_id: 4 }));

 printjson(products.updateOne(
   { product_id: 4, "attributes.warranty_months": 12 },
   { $set: { "attributes.warranty_months": 18 } }
 ));

 print("After update:");
 printjson(products.findOne({ product_id: 4 }));

 // SECTION B: RESTORE ORIGINAL WARRANTY (18 -> 12 MONTHS)
 // Atlas Filter: { "product_id": 4 }
 // Atlas Action:
 // 1. Find the Electric Kettle document.
 // 2. Click Edit.
 // 3. Change attributes.warranty_months from 18 back to 12.
 // 4. Save and verify the original value.
 // No screenshot required.

 print("Restore original warranty:");

 printjson(products.updateOne(
   { product_id: 4, "attributes.warranty_months": 18 },
   { $set: { "attributes.warranty_months": 12 } }
 ));

 printjson(products.findOne({ product_id: 4 }));

 // SECTION C: INSERT TEMPORARY DOCUMENT
 // Atlas Action:
 // 1. Click Add Data -> Insert Document.
 // 2. Select JSON mode.
 // 3. Insert the temporary document below.
 //
 // Atlas Insert Document (JSON):
 // {
 //   "product_id": 9001,
 //   "product_name": "Temporary Test Product",
 //   "category": "Demonstration",
 //   "price": 1000,
 //   "currency": "NGN",
 //   "attributes": { "purpose": "delete-test" },
 //   "stock_by_branch": []
 // }
 //
 // Atlas Filter: { "product_id": 9001 }
 // Screenshot: 08-temporary-document.png
 //
 // Note: $setOnInsert with upsert:true avoids inserting
 // another record if product_id 9001 already exists.

 print("Insert temporary test product:");

 printjson(products.updateOne(
   { product_id: 9001 },
   {
     $setOnInsert: {
       product_id: 9001,
       product_name: "Temporary Test Product",
       category: "Demonstration",
       price: 1000,
       currency: "NGN",
       attributes: { purpose: "delete-test" },
       stock_by_branch: []
     }
   },
   { upsert: true }
 ));

 printjson(products.findOne({ product_id: 9001 }));

 // SECTION D: DELETE TEMPORARY DOCUMENT
 // Atlas Filter: { "product_id": 9001 }
 // Atlas Action:
 // 1. Find Temporary Test Product.
 // 2. Click the Delete icon for that document.
 // 3. Confirm deletion.
 // 4. Run the same filter again to verify zero results.
 // Screenshot: 09-delete-verification.png
 //
 // Final Atlas Filter: {}
 // Verify the four original products remain.
 // Screenshot: 10-final-collection.png

 print("Delete temporary test product:");

 printjson(products.deleteOne({
   product_id: 9001,
   category: "Demonstration"
 }));

 print("Verify deletion:");
 printjson(products.findOne({ product_id: 9001 }));
 // Expected: null
