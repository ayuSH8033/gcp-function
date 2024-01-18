from flask import Flask, jsonify
import functions_framework
import psycopg2
import logging
from .utils import  db_params
from .queries import queries
from geopy.distance import geodesic

db_config = db_params
logging.basicConfig(level=logging.INFO)

def verify_location(request):
    if request.method == 'GET':
            task_id = request.args.get('task_id')
            location = request.args.get('location')
            logging.info("Connecting to the database...")
            conn = psycopg2.connect(**db_config)
            logging.info("Database connected successfully.")
            cursor = conn.cursor()
            if task_id and location:
                lon, lat = map(float, location.split(','))
                try:
                    cursor.execute(queries.SELECT_OUTLET_COORDINATES, (task_id,))
                    outlet_coordinates = cursor.fetchone()
                    logging.info(outlet_coordinates)
                    if outlet_coordinates:
                        distance = geodesic(location, outlet_coordinates).meters
                        thershold = 0
                        if distance == thershold:
                            output = "passed"
                        else:
                            output = "failed"

                        return jsonify({'output': output, 'error': "False" }), 200

                    else:
                        return jsonify({
                            "message": "Outlet not found for the given task_id",
                            "error": True
                        })

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

            if task_id == "":
                logging.error(f"task_id not entered")
                return jsonify({
                    "message": "please enter task_id",
                    "error": True
                })

            if location == "":
                logging.error(f"location_id not entered")
                return jsonify({
                    "message": "please enter location_id",
                    "error": True
                })

            else:
                return jsonify({
                    "message": "Please provide both task_id and location parameters",
                    "error": True
                })
    else:
        return jsonify({"message": " Method Not Allowed", "error": True}), 405