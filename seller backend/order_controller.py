from flask import request, jsonify
from app import mysql
from collections import defaultdict

def order_history():
    try:
        cur = mysql.connection.cursor()
        query = """SELECT 
            o.OrderId,
            o.OrderDateTime,
            o.RetailerId,
            r.RetailerEmail,
            o.TotalPrice,
            od.ProductId,
            p.ProductName
        FROM `order` o
        JOIN retailer r ON o.RetailerId = r.RetailerId
        JOIN orderdetail od ON o.OrderId = od.OrderId
        JOIN product p ON od.ProductId = p.ProductId
        """
        cur.execute(query)
        orders = cur.fetchall()
        cur.close()
        
        grouped_orders = defaultdict(lambda: {
            "OrderId": None,
            "OrderDateTime": None,
            "RetailerId": None,
            "RetailerEmail": None,
            "TotalPrice": None,
            "Products": []
        })
        
        for order in orders:
            order_id = order[0]
            if not grouped_orders[order_id]["OrderId"]:
                grouped_orders[order_id].update({
                    "OrderId": order[0],
                    "OrderDateTime": order[1],
                    "RetailerId": order[2],
                    "RetailerEmail": order[3],
                    "TotalPrice": order[4]
                })
            grouped_orders[order_id]["Products"].append({
                "ProductId": order[5],
                "ProductName": order[6]
            })
        
        return jsonify(list(grouped_orders.values())), 200
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500