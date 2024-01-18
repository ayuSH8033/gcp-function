from flask import Flask, jsonify
import functions_framework
import psycopg2
import logging
from .utils import  db_params
from .queries import queries

#calling_database_connection_config in db_config variable
db_config = db_params
logging.basicConfig(level=logging.INFO)

@functions_framework.http
def get_user_details(request):
    if request.method == 'GET':
        user_id = request.args.get('user_id')
        logging.info("Connecting to the database...")
        conn = psycopg2.connect(**db_config)
        logging.info("Database connected successfully.")
        cursor = conn.cursor()
        if user_id:
            try:
                cursor.execute(queries.Get_User_details, (user_id,))
                # logging.info((f'{queries.Get_User_details, (user_id,)}'))
                user_data = cursor.fetchone()
                logging.info(str(user_data))
                if user_data:
                    logging.info(str(user_data))
                    user_profile = {
                        "id": user_data[0],
                        "role": user_data[1],
                        "created_at": str(user_data[2]),
                        "updated_at": str(user_data[3]),
                        "name": user_data[4],
                        "profile_image": user_data[5],
                        "email": user_data[6]
                    }
                    return jsonify({"user_profile": user_profile, "error": False}), 200
                else:
                    return jsonify({"error": False , "message": "User not exist"}), 200
            except psycopg2.Error as e:
                logging.error(f"Database error: {str(e)}")
                return jsonify({
                    "message": "Database error",
                    "error": True
                })
            finally:
                if conn:
                    cursor.close()
                    conn.close()
                    logging.info("Database connection closed.")
        else:
            return jsonify({
                "message": "Bad Request: Missing user_id",
                "error": True
            }), 400
    else:
        return jsonify({'message': 'Method not allowed'}), 405
