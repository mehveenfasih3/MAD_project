from flask import Flask, request, jsonify, render_template, redirect, url_for, send_file
from flask_mysqldb import MySQL
from collections import defaultdict

import bcrypt
import os
from PIL import Image
from werkzeug.utils import secure_filename
from pyzbar.pyzbar import decode
import cv2 as cv2
import pytesseract
import re
from datetime import datetime
from flask_cors import CORS
import cloudinary
import cloudinary.uploader
      
cloudinary.config( 
    cloud_name = "djeipse9i", 
    api_key = "515717114637578", 
    api_secret = "8AGTfR4RUcjooVD_CZey9Y37Kuw",
    secure=True
)
UPLOAD_FOLDER = "uploads"  


app = Flask(__name__)
CORS(app)  
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '23sep2004'
app.config['MYSQL_DB'] = 'smart supply'

mysql = MySQL(app)

print('my sql',mysql)
if not mysql:
    print("Error: MySQL connection not established!")
    exit()
expiry_date_global="None"
seller_id_global="None"
@app.route('/add_product', methods=['POST'])
def add_product():
    try:
        global seller_id_global
        print(" Add product" ,seller_id_global)
        product_name = request.form.get('ProductName')
        product_type = request.form.get('ProductType')
        product_quantity = request.form.get('ProductQuantity')
        product_price = request.form.get('ProductPrice')
        product_description = request.form.get('ProductDescription')
        product_expiry_date = request.form.get('ProductExpiryDate')

        
        if not all([product_name, product_type, product_quantity, product_price, product_description, product_expiry_date]):
            return jsonify({"status": "error", "message": "All fields are required"}), 400

        
        product_image_path = None
        
        if 'ProductImage' in request.files:
            product_image = request.files['ProductImage']
            upload_result = cloudinary.uploader.upload(product_image) 
            product_image_path=upload_result['secure_url'] 
           
        
        cursor = mysql.connection.cursor()

        cursor.execute("SELECT MAX(ProductId) FROM product")
        last_id = cursor.fetchone()[0]
        new_id = last_id + 1 if last_id else 1  

       
        query = """
        INSERT INTO product (ProductId, ProductName, ProductType, ProductPrice, 
                              ProductQuantity, ProductDescription, ProductExpiryDate, 
                              ProductPayment, ProductImage, SellerId, ProductDiscount) 
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        product_data = (
            new_id, product_name, product_type, product_price, 
            product_quantity, product_description, product_expiry_date,
            'false', product_image_path, seller_id_global, 0.00
        )
      
        cursor.execute(query, product_data)  
        mysql.connection.commit()
        cursor.close()

        print(f"Product inserted successfully with ProductId: {new_id}")
             
        return jsonify({
            "status": "success",
            "message": "Product added successfully",
            "ProductId": new_id,
            "ProductImagePath": product_image_path if product_image_path else "No image uploaded"
        }), 201

    except Exception as e:
        print("Error inserting product:", e)
        return jsonify({"status": "error", "message": str(e)}), 500



@app.route('/add_barcode', methods=['POST'])
def add_barcode():
    global expiry_date_global
    if 'image' not in request.files:
        return {"message": "No image uploaded"}, 400
    
    image = request.files['image']
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)

   
    image_path = os.path.join(app.config["UPLOAD_FOLDER"], image.filename)
    image.save(image_path)
    print("image save successfully")

   
    if not os.path.exists(image_path):
        return jsonify({"message": "Image not saved properly!"}), 500
    

   
    
    
    expiry_date = cv(image_path)  
    
    print(expiry_date)
    if expiry_date:
        expiry_date_global=expiry_date
        print(f"Expiry Date Stored: {expiry_date_global}")
        return {"message": "Image uploaded successfully","expiry_date": expiry_date}, 200
    else:
        return {"message": "Image uploaded successfully, but no expiry date found"}, 200

    
def cv(image):
    print("yeh agye hay yahan ",image)
    print("Received image path: ", image)
    
   
    image=cv2.imread(image)
    image = cv2.resize(image, None, fx=2, fy=2, interpolation=cv2.INTER_CUBIC)
 
#     image = Image.open(image_path)

# # Decode the barcode
#     decoded_objects = decode(image)

#     for obj in decoded_objects:
#      print("Decoded Data:", obj.data.decode("utf-8"))
    
    if image is None:
        print("Error: Could not load image. Check the file path!")
        return

    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    print("Gray",gray)

    _, thresh = cv2.threshold(gray, 150, 255, cv2.THRESH_BINARY)
    print("Thresh",thresh)
    pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

    print(pytesseract.get_tesseract_version())
    from PIL import Image


    thresh_pil = Image.fromarray(thresh)
    print(thresh_pil)

    extracted_text = pytesseract.image_to_string(thresh_pil)

    print("Extracted Text:", extracted_text)
    matches = re.findall(r'\(\d+\)\s*(\d{6})\s*\(\d+\)', extracted_text)
    print(matches)

    def validate_date(yy, mm, dd):
        try:
            datetime(year=2000 + int(yy), month=int(mm), day=int(dd))
            return True
        except ValueError:
            return False


    for match in matches:
        yy, mm, dd = match[:2], match[2:4], match[4:6]
        
        if validate_date(yy, mm, dd):
            expiry_date = f"20{yy}-{mm}-{dd}"
            
            return expiry_date
            #print(f"Expiry Date Found: {expiry_date}")
            # get_expiry(expiry_date)
            break  
    else:
        print("No valid expiry date found.")

# b=cv('sample3.png')
# print(b)
@app.route('/get_expiry', methods=['GET'])
def get_expiry():
    
    global expiry_date_global
    if expiry_date_global:
        return jsonify({"status": "success", "expiry_date": expiry_date_global}), 200
    else:
        return jsonify({"status": "error", "message": "No expiry date provided"}), 400





@app.route('/get_sellers_information', methods=['GET'])
def get_sellers_information():
    try:
        global seller_id_global
        print("drawer",seller_id_global)
        cursor = mysql.connection.cursor()
        query = """SELECT * FROM seller WHERE SellerId = %s;"""
        cursor.execute(query,(seller_id_global,))

       
        products = cursor.fetchall()
        column_names = [desc[0] for desc in cursor.description]
        
        cursor.close()  
        
        
        product_list = [dict(zip(column_names, row)) for row in products]

       
        for product in product_list:
            print(product)  

        return jsonify({"status": "success", "data": product_list}), 200

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

@app.route('/get_products', methods=['GET'])
def get_products():
    try:
        global seller_id_global
        seller_id_global
        print("alerts",seller_id_global)
        print("SellerId Type:", type(seller_id_global), "Value:", seller_id_global)

        cursor = mysql.connection.cursor()
        # query = """SELECT *,DATE_FORMAT(ProductExpiryDate, '%Y-%m-%d') AS FormattedExpiryDate, DATEDIFF(ProductExpiryDate,CURDATE()) AS Days FROM product WHERE DATEDIFF(ProductExpiryDate,CURDATE()) >= 10 AND SellerId = 1;"""
        # cursor.execute(query)
        query = """SELECT *, DATE_FORMAT(ProductExpiryDate, '%%Y-%%m-%%d') AS FormattedExpiryDate, 
                   DATEDIFF(ProductExpiryDate, CURDATE()) AS Days 
                   FROM product WHERE DATEDIFF(ProductExpiryDate, CURDATE())BETWEEN 1 AND 7 
                   AND SellerId = %s;"""

        final_query = query.replace("%s", str(seller_id_global))  # Debugging
        print("Executing Query:", final_query)

        cursor.execute(query, (seller_id_global,))
        # print("alerts",seller_id_global)
        # cursor.execute(query, (seller_id_global,))

       
        products = cursor.fetchall()
        column_names = [desc[0] for desc in cursor.description]
        
        cursor.close()  
        
        
        product_list = [dict(zip(column_names, row)) for row in products]

       
        for product in product_list:
            print(product)  

        return jsonify({"status": "success", "data": product_list}), 200

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})
    


@app.route('/get_orders', methods=['GET'])
def get_orders():
    try:
        global seller_id_global
        seller_id_global
        print(seller_id_global)
        cur = mysql.connection.cursor()
        query = """SELECT 
            o.OrderId,
            DATE_FORMAT(o.OrderDateTime, '%%Y-%%m-%%d') AS OrderDateTime,
            o.RetailerId,
            r.RetailerEmail,
            o.TotalPrice,
            od.ProductId,
            p.ProductName

        FROM `order` o
        JOIN retailer r ON o.RetailerId = r.RetailerId
        JOIN orderdetail od ON o.OrderId = od.OrderId
        JOIN product p ON od.ProductId = p.ProductId
        WHERE p.SellerId=%s

        """
        final_query = query.replace("%s", str(seller_id_global))  # Debugging
        print("Executing Query:", final_query)

        cur.execute(query,(seller_id_global,))
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
        return jsonify({"error": str(e)})
@app.route('/get_own_products', methods=['GET'])
def get_own_products():
    try:
        global seller_id_global
        cur = mysql.connection.cursor()
        query = """SELECT 
            ProductId,
            ProductName,
            ProductType,
            ProductPrice,
            ProductQuantity,
            ProductDescription,
            ProductExpiryDate,
            ProductDiscount,
            ProductImage
        FROM product
        WHERE ProductExpiryDate>CURDATE() AND ProductPayment="false" AND SellerId=%s;
        """
        final_query = query.replace("%s", str(seller_id_global))  # Debugging
        print("Executing Query:", final_query)

        cur.execute(query, (seller_id_global,))
        
        #cur.execute(query)
        products = cur.fetchall()
        cur.close()
        
        grouped_products = defaultdict(lambda: {
            "ProductId": None,
            "ProductName": None,
            "ProductType": None,
            "ProductPrice": None,
            "ProductQuantity": None,
            "ProductDescription": None,
            "ProductExpiryDate": None,
            "ProductDiscount": None,
            "ProductImage": None,
        })
        
        for product in products:
            product_id = product[0]
            grouped_products[product_id].update({
                "ProductId": product[0],
                "ProductName": product[1],
                "ProductType": product[2],
                "ProductPrice": product[3],
                "ProductQuantity": product[4],
                "ProductDescription": product[5],
                "ProductExpiryDate": product[6],
                "ProductDiscount": product[7],
                "ProductImage": product[8]

            })
        
        return jsonify(list(grouped_products.values())), 200
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500
    
@app.route('/update_discount/<int:product_id>', methods=['POST'])
def update_discount(product_id):
    try:
        data = request.get_json()
        discount = data.get("ProductDiscount")
        cur = mysql.connection.cursor()
        cur.execute("UPDATE product SET ProductDiscount = %s WHERE ProductId = %s", (discount, product_id))
        mysql.connection.commit()
        cur.close()

        return jsonify(data), 200
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500
    



@app.route('/api/signup', methods=['POST'])
def signup():
    data = request.get_json()

    # Extract data from the request
    factory_name = data.get('factory_name')
    email = data.get('email')
    phone = data.get('phone')
    password = data.get('password')
    factory_address = data.get('factory_address')
    account_number = data.get('account_number')

    # Generate a new SellerId
    seller_id = get_next_seller_id()
    print(seller_id)

    # Insert data into the database
    try:
        cur = mysql.connection.cursor()
       
        query = """
            INSERT INTO seller (SellerId, SellerName, SellerEmail, SellerPassword, SellerLocation)
            VALUES (%s, %s, %s, %s, %s)
        """
        sellerdata=(seller_id, factory_name, email, password, factory_address)
        cur.execute(query, sellerdata)
       
        mysql.connection.commit()
       

        cur.close()
       
        return jsonify({'message': 'Signup successful'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

def get_next_seller_id():
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT MAX(SellerId) FROM seller")
    max_id = cur.fetchone()[0]
    cur.close()

    return max_id + 1 if max_id else 1  # Start with 1 if the table is empty

@app.route('/api/seller_login', methods=['POST'])
def seller_login():
    data = request.get_json()

    # Extract data from the request
    email = data.get('email')
    password = data.get('password')

    # Verify login credentials
    try:
        
        cur = mysql.connection.cursor()
        query = """
            SELECT * FROM seller WHERE SellerEmail = %s AND SellerPassword = %s
        """
        cur.execute(query, (email, password))
        seller = cur.fetchone()
        global seller_id_global
        seller_id_global=seller[0]

        cur.close()
        

        if seller:
            return jsonify({'message': 'Login successful', 'seller': seller}), 200
        
        else:
            return jsonify({'error': 'Invalid email or password'}), 401
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/orders', methods=['GET'])
def getorders():
    try:
        cursor=mysql.connection.cursor()
        #cursor = connection.cursor(dictionary=True)

        # Fetch all orders with OrderDateTime in ISO 8601 format
        cursor.execute("""
            SELECT OrderId, DATE_FORMAT(OrderDateTime, '%Y-%m-%dT%H:%i:%sZ') AS OrderDateTime
            FROM `order`
        """)
        orders = cursor.fetchall()

        cursor.close()
        #connection.close()

        return jsonify(orders), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
@app.route('/api/product_sales', methods=['GET'])
def get_product_sales():
    try:
        cursor=mysql.connection.cursor()
        #cursor = connection.cursor(dictionary=True)

        # Get query parameter for period
        period = request.args.get('period')  # "weekly" or "monthly"

        if period == "weekly":
            query = """
                SELECT od.ProductId, COUNT(*) as sales,
                       WEEKDAY(o.OrderDateTime) as day_of_week
                FROM orderdetail od
                JOIN `order` o ON od.OrderId = o.OrderId
                JOIN `product` p ON od.ProductId=p.ProductId
                WHERE p.SellerId = %s
                GROUP BY od.ProductId, WEEKDAY(o.OrderDateTime)
                
            """
        elif period == "monthly":
            query = """
                SELECT od.ProductId, COUNT(*) as sales,
                       MONTH(o.OrderDateTime) as month_of_year
                FROM orderdetail od
                JOIN `order` o ON od.OrderId = o.OrderId
                JOIN `product` p ON od.ProductId=p.ProductId
                WHERE p.SellerId = %s
                GROUP BY od.ProductId, MONTH(o.OrderDateTime)
                
            """
        else:
            # Default to weekly if no period specified
            query = """
                SELECT od.ProductId, COUNT(*) as sales,
                       WEEKDAY(o.OrderDateTime) as day_of_week
                FROM orderdetail od
                JOIN `order` o ON od.OrderId = o.OrderId
                JOIN `product` p ON od.ProductId=p.ProductId
                WHERE p.SellerId = %s
                GROUP BY od.ProductId, WEEKDAY(o.OrderDateTime)
            """
        global seller_id_global
        print("graphs",seller_id_global)
        print(f"Executing query: {query}")
        cursor.execute(query,(seller_id_global,))
        product_sales = cursor.fetchall()
        print(f"Query results: {product_sales}")

        cursor.close()
        

        return jsonify(product_sales), 200
    except Exception as e:
        print(f"Error: {str(e)}")
        return jsonify({'error': str(e)}), 500
    
with app.app_context():
   
   
    response, status_code = get_own_products()  
    print(response.get_json())  
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
