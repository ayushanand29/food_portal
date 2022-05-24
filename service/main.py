import pymysql
import json
from db import app, mysql
from flask import jsonify
from flask import flash, request, render_template, redirect, url_for

# Route Address: http://127.0.0.1/
# This endpoint directs us to index.html
@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')

# Route Address: http://127.0.0.1/log_in
# This endpoint directs us to log in screen of the user
@app.route('/log_in', methods=['GET','POST'])
def log_in():
    error = None
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        _email = request.form['email']
        _password = request.form['password']
        if _email == "" or _password == "":
            return render_template('log_in.html', authFail=False, emptyFields=True)
        sql = "SELECT auth_string FROM users WHERE email=%s"
        data = (_email)
        cursor.execute(sql, data)
        row = cursor.fetchone()
        resp = jsonify(row)
        cursor.close()
        conn.close()
        if row == None:
            return render_template('log_in.html', authFail=True, emptyFields=False)
        if row[0] == _password:
            global user
            user = _email
            return redirect(url_for('home'))
        else:
            return render_template('log_in.html', authFail=True, emptyFields=False)
    return render_template('log_in.html')

# Route Address: http://127.0.0.1/register
# This endpoint directs us to sign up sheet
@app.route('/register', methods=['GET','POST'])
def add_user():
    error = None
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        _name = request.form['name']
        _email = request.form['email']
        _password = request.form['password']
        _phone_number = request.form['phone_number']
        if _name == "" or _email == "" or _password == "" or _phone_number == "":
           return render_template('sign_up.html', emptyFields=True) 
        sql = "INSERT INTO users(name, email, auth_string, phone_number) VALUES(%s, %s, %s, %s)"
        data = (_name, _email, _password, _phone_number)
        cursor.execute(sql, data)
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('success_register'))
    return render_template('sign_up.html', error=error)

# Route Address: http://127.0.0.1/res_log_in
# This endpoint directs us to log in screen of the employee
@app.route('/res_log_in', methods=['GET','POST'])
def res_log_in():
    error = None
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        _email = request.form['email']
        _password = request.form['password']
        _res_id = request.form['res_id']
        if _email == "" or _password == "" or _res_id == "":
            return render_template('res_log_in.html', authFail=False, emptyFields=True)
        sql = "SELECT auth_string FROM restaurant_staff WHERE email=%s AND res_id=%s"
        data = (_email, _res_id)
        cursor.execute(sql, data)
        row = cursor.fetchone()
        resp = jsonify(row)
        cursor.close()
        conn.close()
        if row == None:
            return render_template('error.html', authFail=False, emptyFields=True)
        if row[0] == _password:
            global res_user
            res_user = _email
            print(res_user)
            return redirect(url_for('admin'))
        else:
            return render_template('error.html', authFail=True, emptyFields=False)
    return render_template('res_log_in.html')

# Route Address: http://127.0.0.1/res_register
# This endpoint directs us to sign up sheet
@app.route('/res_register', methods=['GET','POST'])
def add_res_user():
    error = None
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        _name = request.form['name']
        _email = request.form['email']
        _password = request.form['password']
        _role = request.form['role']
        _res_id = request.form['res_id']
        if _name == "" or _email == "" or _password == "" or _role == "" or _res_id == "":
           return render_template('res_sign_up.html', emptyFields=True) 
        sql = "INSERT INTO restaurant_staff(name, email, auth_string, role, res_id) VALUES(%s, %s, %s, %s, %s)"
        data = (_name, _email, _password, _role, _res_id)
        cursor.execute(sql, data)
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('success_register'))
    return render_template('res_sign_up.html', error=error)

# Route Address: 127.0.0.1/home
# This endpoint redirects us to the home page when the user successfully logs in the application
@app.route('/home', methods=['GET'])
def home():
    conn = mysql.connect()
    cursor = conn.cursor()
    sql = "SELECT * FROM restaurant"
    cursor.execute(sql)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('home.html', data=rows)

@app.route('/order_summary/<string:data>/<int:res_id>', methods=['GET', 'POST'])
def order_summary(data, res_id):
    data = data.replace("'", '"')
    message = json.loads(data)
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        amounts = request.form.getlist('quantity')
        item_ids = request.form.getlist('item_id')
        print(message)
        print(amounts)
        print(item_ids)
        for i, name in enumerate(item_ids):
            total_price_of_item = message[name] * int(amounts[i])
            message[name] = total_price_of_item
            print(total_price_of_item)
        print("=========")
        print(user)
        print("=========")
        sql = "SELECT id FROM users WHERE email=\"{}\"".format(user)
        print(sql)
        cursor.execute(sql)
        row = cursor.fetchone()
        sql = "INSERT INTO food_order(customer_id, res_id, order_status) VALUES ({0}, {1}, \"{2}\")".format(int(row[0]),res_id, "PAYMENT_PENDING")
        # data = ()
        print(sql)
        cursor.execute(sql)
        conn.commit()
        cursor.close()
        conn.close()
        print(user)
        return redirect(url_for('checkout', data=message, res_id=res_id))
    return render_template('order_summary.html', data=message)



@app.route('/success_register', methods=['GET'])
def success_register():
    return render_template('success.html')

@app.route('/update_address', methods=['GET', 'POST'])
def update_address():
    error = None
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        _address = request.form['address']
        _landmark = request.form['landmark']
        _city = request.form['city']
        _state = request.form['state']
        _pincode = request.form['pincode']
        _password = request.form['auth_string']
        sql = "SELECT auth_string, id FROM users WHERE email=%s"
        data = (user)
        cursor.execute(sql, data)
        row = cursor.fetchone()
        if row[0] == _password:
            sql = "INSERT INTO address(user_id, address, landmark, city, state, pincode) VALUES(%s, %s, %s, %s, %s, %s)"
            data = (row[1], _address, _landmark, _city, _state, _pincode)
            cursor.execute(sql, data)
            conn.commit()
            resp = jsonify('User address updated successfully!')
            resp.status_code = 200
            cursor.close()
            conn.close()
            return resp
        else:
            resp = jsonify('Incorrect password')
            resp.status_code = 404
            cursor.close()
            conn.close()
    return render_template('address.html')

@app.route('/show_restaurants', methods=['GET'])
def show_restaurants():
    error = None
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM restaurant")
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('restaurant.html', data=data)

@app.route('/restaurant/<int:id>', methods=['GET','POST'])
def restaurant(id):
    if request.method == 'POST':
        drinks = request.form.getlist('drink')
        deserts = request.form.getlist('desert')
        main = request.form.getlist('main')
        starters = request.form.getlist('starter')
        conn = mysql.connect()
        cursor = conn.cursor(pymysql.cursors.DictCursor)
        case_list = {}
        sql = "SELECT price FROM menu WHERE res_id=%s AND name=%s"
        for name in drinks:
            data = (id, name)
            cursor.execute(sql, data)
            row = cursor.fetchone()
            case_list[name] = row['price']
        for name in deserts:
            data = (id, name)
            cursor.execute(sql, data)
            row = cursor.fetchone()
            case_list[name] = row['price']
        for name in main:
            data = (id, name)
            cursor.execute(sql, data)
            row = cursor.fetchone()
            case_list[name] = row['price']
        for name in starters:
            data = (id, name)
            cursor.execute(sql, data)
            row = cursor.fetchone()
            case_list[name] = row['price']
        return redirect(url_for('order_summary',data=case_list, res_id=id))
    try:
        conn = mysql.connect()
        cursor = conn.cursor(pymysql.cursors.DictCursor)
        #cursor.execute("SELECT name, price, description, type FROM menu WHERE res_id=%s", id)
        cursor.execute("SELECT name FROM restaurant WHERE id=%s", id)
        res_name = cursor.fetchone()
        cursor.callproc('restaurantDetails', [id])
        row = cursor.fetchall()
        print(row)
        return render_template('restaurant.html', data=row, res_name=res_name)
    except Exception as e:
        print(e)
    finally:
        cursor.close()
        conn.close()

@app.route('/payment/<string:data>/<int:res_id>', methods=['GET', 'POST'])
def checkout(data, res_id):
    error = None
    data = data.replace("'", '"')
    message = json.loads(data)
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        _address = request.form['address']
        _landmark = request.form['landmark']
        _city = request.form['city']
        _state = request.form['state']
        _pincode = request.form['zip']
        global user
        sql = "SELECT id FROM users WHERE email=\"{}\"".format(user)
        cursor.execute(sql)
        row = cursor.fetchone()
        sql = "INSERT INTO address(user_id, address, landmark, city, state, pincode) VALUES(%s, %s, %s, %s, %s, %s)"
        data = (int(row[0]), _address, _landmark, _city, _state, _pincode)
        cursor.execute(sql, data)
        conn.commit()
        sql = "UPDATE food_order SET order_status=\"PAYMENT_SUCCESSFULL\" WHERE customer_id={0} AND res_id={1}".format(int(row[0]),res_id)
        print(sql)
        cursor.execute(sql)
        conn.commit()
        print(res_id)
        print(row[0])
        # sql = "SELECT id FROM food_order WHERE customer_id={0} AND res_id={1}".format(int(row[0]), res_id)
        cursor.callproc('getOrderId', [int(row[0]),res_id])
        # print(sql)
        # cursor.execute(sql)
        order_id = cursor.fetchone()
        for item in message:
            print(item)
            sql = "SELECT id FROM menu WHERE name=\"{0}\" AND res_id={1}".format(item, res_id)
            cursor.execute(sql)
            menu = cursor.fetchone()
            cursor.callproc('menuItemPrice', [menu[0]])
            menuItemPrice = cursor.fetchone()
            quantity = int(message[item] / menuItemPrice[0])
            sql = "INSERT INTO order_details(order_id, menu_id, quantity, order_status, price) VALUES ({0},{1},{2},\"FOOD PREPARING\",{3})".format(order_id[0], menu[0], quantity, message[item])
            print(sql)
            cursor.execute(sql)
            conn.commit()
        cursor.close()
        conn.close()
        return render_template('success.html')
    
    return render_template('payment.html', data=message)

@app.route('/admin', methods=['GET'])
def admin():
    print(res_user)
    return render_template('admin.html')

@app.route('/add_item', methods=['GET', 'POST'])
def add_item():
    error = None
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        _name = request.form['name']
        _price = request.form['price']
        _description = request.form['description']
        _type = 'MAIN'
        cursor.callproc('getResId', res_user)
        res_id = cursor.fetchone()
        sql = "INSERT INTO menu(res_id, name, price, description, type) VALUES(%s, %s, %s, %s, %s)"
        data = (res_id, _name, _price, _description, _type)
        cursor.execute(sql, data)
        conn.commit()
        resp = jsonify('Menu item added successfully!')
        resp.status_code = 200
        cursor.close()
        conn.close()
        return resp
    return render_template('add_item.html')

@app.route('/delete_item', methods=['GET', 'POST'])
def delete_item():
    error = None
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        delete_list = request.form.getlist('delete')
        print(delete_list)
        for a in delete_list:
            sql = "DELETE FROM menu WHERE id=%s"
            data = (a)
            print(sql)
            print(data)
            cursor.execute(sql, data)
            conn.commit()
        resp = jsonify('Menu items deleted successfully!')
        resp.status_code = 200
        cursor.close()
        conn.close()
        return resp
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.callproc('getResId', res_user)
    res_id = cursor.fetchone()
    sql = "SELECT id, name, price, description, type FROM menu WHERE res_id=%s"
    data=(res_id)
    cursor.execute(sql, data)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('delete_item.html', data=rows)


@app.route('/order', methods=['GET', 'POST'])
def order():
    error = None
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        update_list = request.form.getlist('status')
        item_ids = request.form.getlist('item_id')
        print(update_list)
        for i, item_id in enumerate(item_ids):
            sql = "UPDATE order_details SET order_status=%s WHERE id=%s"
            data = (update_list[i],item_id)
            print(sql)
            print(data)
            cursor.execute(sql, data)
            conn.commit()
        resp = jsonify('Menu items updated successfully!')
        resp.status_code = 200
        cursor.close()
        conn.close()
        return resp
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.callproc('getResId', res_user)
    res_id = cursor.fetchone()
    sql = "SELECT o.id, o.order_id, o.menu_id, o.quantity, o.order_status FROM order_details as o INNER JOIN menu m ON o.menu_id=m.id and m.res_id={}".format(res_id[0])
    print(sql)
    cursor.execute(sql)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('orders.html', data=rows)

@app.errorhandler(404)
def not_found(error=None):
    message = {
        'status': 404,
        'message': 'Not Found: ' + request.url,
    }
    resp = jsonify(message)
    resp.status_code = 404

    return resp

user = ""
res_user = ""

if __name__ == "__main__":
    from db import readConfig, connectToDb
    data = readConfig()

    connectToDb(data, app)
    app.run(debug=True)
