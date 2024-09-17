from robot_control_class import RobotControl
import math

def get_highest_lowest():
    rc = RobotControl()
    laser = rc.get_laser_full()
    laser_dict = {}
    output = []
    
    for i, elem in enumerate(laser):
        if not math.isinf(elem):
            laser_dict[i] = elem
    
    if not laser_dict:
        # Return an empty list if no valid laser readings
        return []

    max_val = max(laser_dict.values())
    min_val = min(laser_dict.values())

    for key, val in laser_dict.items():
        if val == max_val:
            output.append(key)
            break

    for key, val in laser_dict.items():
        if val == min_val:
            output.append(key)
            break

    return output

# Explicitly test the function
if __name__ == "__main__":
    result = get_highest_lowest()
    print("Result:", result)
