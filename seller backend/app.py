from flask import Flask, request, jsonify, render_template, redirect, url_for, send_file
from flask_mysqldb import MySQL
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
@app.route('/add_product', methods=['POST'])
def add_product():
    try:
       
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
            'false', product_image_path, 1, 0.00
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
    
   
    image=cv2.imread('uploads/78f42b5f-6561-44e5-a0cd-e521ba97e6ee9125722942604037949.jpg')
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
@app.route('/get_expiry', methods=['GET'])
def get_expiry():
    
    global expiry_date_global
    if expiry_date_global:
        return jsonify({"status": "success", "expiry_date": expiry_date_global}), 200
    else:
        return jsonify({"status": "error", "message": "No expiry date provided"}), 400




@app.route('/get_products', methods=['GET'])
def get_products():
    try:
        cursor = mysql.connection.cursor()
        query = "SELECT *,DATE_FORMAT(ProductExpiryDate, '%Y-%m-%d') AS FormattedExpiryDate, DATEDIFF(ProductExpiryDate,CURDATE()) AS Days FROM product WHERE DATEDIFF(ProductExpiryDate,CURDATE()) >= 10;"
        cursor.execute(query)

       
        products = cursor.fetchall()
        column_names = [desc[0] for desc in cursor.description]
        
        cursor.close()  
        
        
        product_list = [dict(zip(column_names, row)) for row in products]

       
        for product in product_list:
            print(product)  

        return jsonify({"status": "success", "data": product_list}), 200

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

with app.app_context():
   
    a=get_products()
    print(a)
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
