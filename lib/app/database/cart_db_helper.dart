import 'dart:convert';

import 'package:shopperz/app/modules/cart/model/cart_model.dart';
import 'package:shopperz/app/modules/cart/model/product_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      'cart.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE cart (
          variationId INTEGER PRIMARY KEY,
          product TEXT,
          quantity INTEGER,
          shippingCharge TEXT,
          finalVariationString TEXT,
          sku TEXT,
          taxObject TEXT,
          stock TEXT,
          shippingObject TEXT,
          totalProductTax REAL,
          flatShippingCharge TEXT,
          variationPrice TEXT,
          variationOldPrice TEXT,
          variationCurrencyPrice TEXT,
          variationOldCurrencyPrice TEXT,
          variationStock INTEGER
        )
      ''');
      },
    );
  }

  // insert the data for cart item
  Future<int> insertCartItem(CartModel cartItem) async {
    final db = await _initDatabase();

    try {
      return await db.insert(
        'cart',
        {
          // Convert product to JSON string
          'product': jsonEncode(cartItem.product.toJson()),
          'quantity': cartItem.quantity.value,
          'variationId': cartItem.variationId,
          'shippingCharge': cartItem.shippingCharge,
          'finalVariationString': cartItem.finalVariationString,
          'sku': cartItem.sku,
          'taxObject': jsonEncode(cartItem.taxObject),
          'stock': jsonEncode(cartItem.stock),
          'shippingObject': jsonEncode(cartItem.shippingObject),
          'totalProductTax': cartItem.totalProductTax,
          'flatShippingCharge': cartItem.flatShippingCharge,
          'variationPrice': jsonEncode(cartItem.variationPrice),
          'variationOldPrice': jsonEncode(cartItem.variationOldPrice),
          'variationCurrencyPrice': jsonEncode(cartItem.variationCurrencyPrice),
          'variationOldCurrencyPrice':
              jsonEncode(cartItem.variationOldCurrencyPrice),
          'variationStock': cartItem.variationStock,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Insert failed: $e");
      return -1; // Error indicator
    }
  }

  // get all the cart items
  Future<List<CartModel>> getCartItems() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('cart');
    return List.generate(maps.length, (i) {
      return CartModel(
        product: ProductModel.fromJson(jsonDecode(maps[i]['product'])),
        quantity: maps[i]['quantity'],
        variationId: maps[i]['variationId'],
        shippingCharge: maps[i]['shippingCharge'],
        finalVariationString: maps[i]['finalVariationString'],
        sku: maps[i]['sku'],
        taxObject: jsonDecode(maps[i]['taxObject']),
        stock: jsonDecode(maps[i]['stock']),
        shippingObject: jsonDecode(maps[i]['shippingObject']),
        totalProductTax: maps[i]['totalProductTax'],
        flatShippingCharge: maps[i]['flatShippingCharge'],
        variationPrice: jsonDecode(maps[i]['variationPrice']),
        variationOldPrice: jsonDecode(maps[i]['variationOldPrice']),
        variationCurrencyPrice: jsonDecode(maps[i]['variationCurrencyPrice']),
        variationOldCurrencyPrice:
            jsonDecode(maps[i]['variationOldCurrencyPrice']),
        variationStock: maps[i]['variationStock'],
      );
    });
  }

  // delete the cart item
  Future<int> deleteCartItem(int variationId) async {
    final db = await _initDatabase();
    try {
      return await db.delete(
        'cart',
        where: 'variationId = ?',
        whereArgs: [variationId],
      );
    } catch (e) {
      print("Insert failed: $e");
      return -1; // Error indicator
    }
  }

  // clear the cart
  Future<void> clearCart() async {
    final db = await _initDatabase();
    await db.delete('cart');
  }
}
