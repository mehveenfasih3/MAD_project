from flask import Flask,request,jsonify
import cv2 as cv2
import pytesseract
import re
from datetime import datetime
from flask_cors import CORS
image = cv2.imread('sample1.jpg')
print(image)

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
        print(f"Expiry Date Found: {expiry_date}")
        break  
else:
    print("No valid expiry date found.")

app = Flask(__name__)
CORS(app)  # Enable Cross-Origin Resource Sharing (CORS)

@app.route('/api', methods=['GET'])
def ascii():
    query = request.args.get('query', default="Hello from Flask", type=str)  # Get query parameter
    return jsonify({"message": f"Flask received: {query}"}), 200  # Send response to Flutter

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)