
SELECT_OUTLET_COORDINATES = """
    SELECT lat, lon FROM taskmanagement.outlet 
    WHERE outlet._id = (
        SELECT "outletid" FROM taskmanagement.task 
        WHERE task."_id" = %s
    );
"""

