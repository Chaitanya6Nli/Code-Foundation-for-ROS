![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/TC-logo-blue.png)

# Code Foundation for ROS

# Exam

This exam is based on a Turtlebot robot, which you already know pretty well since it has been used alongside the Courses.

![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/kobuki.jpg)

The scene is composed by 3 walls building an square shaped room, with a small opening on one of the corners.

![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/python_exam_scene.png)

For passing the exam, we will ask you to perform different tasks with the simulated robot (not all the exercises will require to interact  with the simulation). For each task, very **specific instructions** will be provided: name of the package, names of the launch files and Python scripts, topic names to use, etc.

It is **VERY IMPORTANT** that you strictly follow these  instructions, since they will allow our automated correction system to  properly test your exam, and assign a score to it. If the names you use  are different from the ones specified in the exam instructions, your  exercise will be marked as **FAILED**, even though it works correctly.

Before starting with the Exam, please make sure that you read and understand the [**Important Notes**](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/Code_Foundation_Exam.html?AWSAccessKeyId=AKIAJLU2ZOTUFJRMDOAA&Signature=0qfXTFwm5Y%2F1ngbWgTMGcIb8awI%3D&Expires=1663922881#important-notes) and [**How to proceed**](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/Code_Foundation_Exam.html?AWSAccessKeyId=AKIAJLU2ZOTUFJRMDOAA&Signature=0qfXTFwm5Y%2F1ngbWgTMGcIb8awI%3D&Expires=1663922881#proceed) sections.

Good luck!

## Tasks to accomplish

This Exam is divided in 2 main parts. In the first one, you will be asked to perform some tasks related to the **Linux for Robotics** course. In the second one, you will be asked to perform some tasks related to the **Python for Robotics** Course.

##  Part 1: Linux for Robotics

###  Task 0

Inside your workspace (**~/catkin_ws/src/**), create a new folder named **linux_exam**. Inside this folder you will place all the files required for the exam. The full path has to be like this:





```
/home/user/catkin_ws/src/linux_exam
```

#### Specifications

- The new folder created has to be a regular folder, **NOT A ROS PACKAGE**.

###  Task 1

Inside the **linux_exam** folder, create a new bash script named **task1.sh**, that does the following:

a) First, it moves inside the **linux_exam** folder.

a) Once it is there, it generates a folder structure like the following one: this->is->my->linux->exam (check *Specifications*)

b) Inside the final folder, named **exam**, it creates a new file named **my_file.py**

c) Finally, it prints to the screen the following string:





```
This bash script has finished!
```

#### Specifications

- The string printed at the end **MUST** be exactly the same as the one showed above.

- The full folders structure has to be like this:





```
/home/user/catkin_ws/src/linux_exam/this/is/my/linux/exam/my_file.py
```

###  Task 2

Given the following ROS commands:

To make the Turtlebot robot perform a **small square** movement:





```
rosrun linux_exam small_square.py
```

![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/small_square.gif)

To make the Turtlebot robot perform a **medium square** movement:





```
rosrun linux_exam medium_square.py
```

![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/medium_square.gif)

To make the Turtlebot robot perform a **big square** movement:





```
rosrun linux_exam big_square.py
```

![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/big_square.gif)

Inside the **linux_exam** folder, create a new bash script, named **task2.sh**, that does the following:

- It receives one parameter, which can contain one of the following values:
  - **small_square**
  - **medium_square**
  - **big_square**

- If the parameter is **small_square**, the bash script will make the Turtlebot robot perform the small square movement.

- If the parameter is **medium_square**, the bash script will make the Turtlebot robot perform the medium square movement.

- If the parameter is **big_square**, the bash script will make the Turtlebot robot perform the big square movement.

#### Specifications

- The name of the parameters received by your bash script **MUST** be exactly the same as the ones specified above.

###  Task 3

Inside the **linux_exam** folder, create a new bash script, named **task3.sh**, that does the following:

a) First, it goes to the folder named **exam**, which you created in Task 1.

b) Once there, it removes any existing file, and it creates 3 new ones, named like this: **exam1.py**, **exam2.py** and **exam3.py**.

c) Finally, it assigns to each file the following permissions:

- **exam1.py**:
  - Owner: Read, Write and Execute
  - Group: Read and Execute
  - All others: Read

- **exam2.py**:
  - Owner: Read and Execute
  - Group: None
  - All others: Execute

- **exam3.py**:
  - Owner: Write
  - Group: Read
  - All others: Execute

##  Part 2: Python for Robotics

###  Task 0

**1.** Inside your workspace (**~/catkin_ws/src/**), create a new folder named **python_exam**. Inside this folder you will place all the files required for the exam. The full path has to be like this:





```
/home/user/catkin_ws/src/python_exam
```

#### Specifications

- The new folder created has to be a regular folder, **NOT A ROS PACKAGE**.

**2.** Copy the RobotControl class below. You will need it in Tasks 1, 2 and 3.

robot_control_class.py





```
#!/usr/bin/env python

import rospy
from geometry_msgs.msg import Twist
from sensor_msgs.msg import LaserScan
import time


class RobotControl():

    def __init__(self, robot_name="turtlebot"):
        rospy.init_node('robot_control_node', anonymous=True)

        if robot_name == "summit":
            rospy.loginfo("Robot Summit...")
            cmd_vel_topic = "/summit_xl_control/cmd_vel"
            # We check sensors working
            self._check_summit_laser_ready()
        else:      
            rospy.loginfo("Robot Turtlebot...")      
            cmd_vel_topic='/cmd_vel'
            self._check_laser_ready()

        # We start the publisher
        self.vel_publisher = rospy.Publisher(cmd_vel_topic, Twist, queue_size=1)
        self.cmd = Twist()        

        self.laser_subscriber = rospy.Subscriber(
            '/kobuki/laser/scan', LaserScan, self.laser_callback)
        self.summit_laser_subscriber = rospy.Subscriber(
            '/hokuyo_base/scan', LaserScan, self.summit_laser_callback)
        
        self.ctrl_c = False
        self.rate = rospy.Rate(1)
        rospy.on_shutdown(self.shutdownhook)

    
    def _check_summit_laser_ready(self):
        self.summit_laser_msg = None
        rospy.loginfo("Checking Summit Laser...")
        while self.summit_laser_msg is None and not rospy.is_shutdown():
            try:
                self.summit_laser_msg = rospy.wait_for_message("/hokuyo_base/scan", LaserScan, timeout=1.0)
                rospy.logdebug("Current /hokuyo_base/scan READY=>" + str(self.summit_laser_msg))

            except:
                rospy.logerr("Current /hokuyo_base/scan not ready yet, retrying for getting scan")
        rospy.loginfo("Checking Summit Laser...DONE")
        return self.summit_laser_msg

    def _check_laser_ready(self):
        self.laser_msg = None
        rospy.loginfo("Checking Laser...")
        while self.laser_msg is None and not rospy.is_shutdown():
            try:
                self.laser_msg = rospy.wait_for_message("/kobuki/laser/scan", LaserScan, timeout=1.0)
                rospy.logdebug("Current /kobuki/laser/scan READY=>" + str(self.laser_msg))

            except:
                rospy.logerr("Current /kobuki/laser/scan not ready yet, retrying for getting scan")
        rospy.loginfo("Checking Laser...DONE")
        return self.laser_msg

    def publish_once_in_cmd_vel(self):
        """
        This is because publishing in topics sometimes fails the first time you publish.
        In continuous publishing systems, this is no big deal, but in systems that publish only
        once, it IS very important.
        """
        while not self.ctrl_c:
            connections = self.vel_publisher.get_num_connections()
            if connections > 0:
                self.vel_publisher.publish(self.cmd)
                #rospy.loginfo("Cmd Published")
                break
            else:
                self.rate.sleep()

    def shutdownhook(self):
        # works better than the rospy.is_shutdown()
        self.ctrl_c = True

    def laser_callback(self, msg):
        self.laser_msg = msg

    def summit_laser_callback(self, msg):
        self.summit_laser_msg = msg

    def get_laser(self, pos):
        time.sleep(1)
        return self.laser_msg.ranges[pos]

    def get_laser_summit(self, pos):
        time.sleep(1)
        return self.summit_laser_msg.ranges[pos]

    def get_front_laser(self):
        time.sleep(1)
        return self.laser_msg.ranges[360]

    def get_laser_full(self):
        time.sleep(1)
        return self.laser_msg.ranges

    def stop_robot(self):
        #rospy.loginfo("shutdown time! Stop the robot")
        self.cmd.linear.x = 0.0
        self.cmd.angular.z = 0.0
        self.publish_once_in_cmd_vel()

    def move_straight(self):

        # Initilize velocities
        self.cmd.linear.x = 0.5
        self.cmd.linear.y = 0
        self.cmd.linear.z = 0
        self.cmd.angular.x = 0
        self.cmd.angular.y = 0
        self.cmd.angular.z = 0

        # Publish the velocity
        self.publish_once_in_cmd_vel()

    def move_straight_time(self, motion, speed, time):

        # Initilize velocities
        self.cmd.linear.y = 0
        self.cmd.linear.z = 0
        self.cmd.angular.x = 0
        self.cmd.angular.y = 0
        self.cmd.angular.z = 0

        if motion == "forward":
            self.cmd.linear.x = speed
        elif motion == "backward":
            self.cmd.linear.x = - speed

        i = 0
        # loop to publish the velocity estimate, current_distance = velocity * (t1 - t0)
        while (i <= time):

            # Publish the velocity
            self.vel_publisher.publish(self.cmd)
            i += 1
            self.rate.sleep()

        # set velocity to zero to stop the robot
        self.stop_robot()

        s = "Moved robot " + motion + " for " + str(time) + " seconds"
        return s


    def turn(self, clockwise, speed, time):

        # Initilize velocities
        self.cmd.linear.x = 0
        self.cmd.linear.y = 0
        self.cmd.linear.z = 0
        self.cmd.angular.x = 0
        self.cmd.angular.y = 0

        if clockwise == "clockwise":
            self.cmd.angular.z = -speed
        else:
            self.cmd.angular.z = speed

        i = 0
        # loop to publish the velocity estimate, current_distance = velocity * (t1 - t0)
        while (i <= time):

            # Publish the velocity
            self.vel_publisher.publish(self.cmd)
            i += 1
            self.rate.sleep()

        # set velocity to zero to stop the robot
        self.stop_robot()

        s = "Turned robot " + clockwise + " for " + str(time) + " seconds"
        return s


if __name__ == '__main__':
    
    robotcontrol_object = RobotControl()
    try:
        robotcontrol_object.move_straight()

    except rospy.ROSInterruptException:
        pass
```

###  Task 1

Inside the **python_exam** folder, create a new Python script named **task1.py**. Inside this script, create a function named **get_highest_lowest**. This function does the following:

a) First, it creates an instance of the `RobotControl` class.

b) Second, it gets all the values of the laser readings and it stores them into a list.

c) Then, it compares all these laser values that you have stored in  the list in order to detect the highest value and the lowest one.

d) Finally, it returns the **position in the list** of the highest and lowest values (check Specifications).

#### Specifications

- The name of the function MUST BE the one specified above: **get_highest_lowest**

- Bear in mind that the function doesn't have to return the values (highest and lowest), but the **position in the list** of those values.

- Your final (after you have tested that it works properly) program MUST contain the **get_highest_lowest** function, but **MUST NOT** contain any call to this function.

- The function has to return the position values in an **specific order**: first, it returns the position of the highest value and second, it returns the position of the lowest value.

- The laser readings list may contain some values that are expressed as **inf**. You **MUST NOT** take these values into account when calculating the highest and lowest value. **Only take into account the numeric values**.

#### Example

Given the following list:





```
[1,2,3,4,5,inf]
```

Your function has to return the position in the list of the numbers 1 (lowest) and 5 (highest).

###  Task 2

Inside the python_exam folder, create a new Python script, named **task2.py**, that does the following:

a) First, it starts moving the robot forwards while it captures the laser readings in front of the robot.

b) When the laser readings detect that there's an obstacle (the wall) at less than 1 meter in front of the robot, the robot will stop its  movement.

c) After it stops, the robot will turn 90 degrees to his right, facing the opening corner in the room (check *Specifications*).

#### Specifications

- After turning 90 degrees, the robot **MUST** end in the orientation showed below (facing the opening corner):

![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/exam_faceing_opening.png) 

Fig. 1

#### Example

Expected behavior:

![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/task2.gif)

###  Task 3

Inside the python_exam folder, create a new Python script, named **task3.py**. Inside this script, create a Python class named **ExamControl**.

The **ExamControl** class has to contain, at least, the following 2 methods:

- **get_laser_readings**: This method, when called, returns the values of the laser readings of the right and left side of the robot (check *Specifications*).

- **main**: This method, when called, makes the Turtlebot robot start the behavior described below: 

1. Initially, the robot starts moving forward, towards the opening in the room.
2. While moving forward, your program keeps checking the values of the laser readings at the right and left sides of the robot.
3. When these laser values indicate that there are no obstacles  detected neither at the left nor at the right side, the robot will stop  it's movement.

Check the *Example* section for more details on the expected behavior.

#### Specifications

- The **names** of the class and the **methods** MUST BE exactly the same as the ones specified above.

- Your final program (after you have tested that it works properly) MUST contain the **ExamControl** class, but **MUST NOT** contain any instance of the class.

- The initial position of the robot for this exercise it's the end position of the robot in the previous Exercise (check [ Fig. 1](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/Code_Foundation_Exam.html?AWSAccessKeyId=AKIAJLU2ZOTUFJRMDOAA&Signature=0qfXTFwm5Y%2F1ngbWgTMGcIb8awI%3D&Expires=1663922881#fig-1)).

- The get_laser_readings method has to return the values in an **specific order**: first, it returns the value of the left side and second, it returns the value of the right side.

- We consider as laser readings from the left and right sides of the  robot, the ones at the extremes of the laser values array. Remember the  following image:

- All the code of the class has to be contained **INSIDE** the class. This means, do not declare any variable or function outside the class.

![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/turtle_laser3.png)

#### Example

Expected behavior:

![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/task3.gif)

### Important Notes

- The exam accounts for 100% of the final grade.
- In order to correct the exams, we use an automated system that tests the files you create. For this automated system, it is **VERY IMPORTANT** that you follow all the instructions given in the Exercises regarding  the names of the files, services, etc. Don't forget to have a look at  the **Specifications** section of each Exercise.
- In order to reset the position of the Turtlebot robot, you can click the following button, at the top-right corner of the simulation window.

![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/reset_sim.png)

- When you have finished the Exam, you can correct it in order to get a Mark. For that, just click on the following button at the top of this  Notebook. 
   ![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/correct_quiz_btn.png)

- If you pass the Exam, you will find your certificate in the **Accomplishments** section. 
   ![img](https://s3.eu-west-1.amazonaws.com/notebooks.ws/exams/img/accomplishments-new.png)

### How to proceed with the exam

- You can use the learning environment to develop and test your code.
- You can recover the previous lessons or consult the internet to search for information.



### Scoring

Scoring is based on how many of the following phases you have achieved.

Part 1:

- **Task 1.a.** The folders structure is generated properly: **0.75 points**
- **Task 1.b.** The file is generated properly: **0.5 point**
- **Task 1.c.** The final sentence is properly printed: **0.5 point**
- **Task 2.a.** The script properly receives and executes the *small_square* argument: **0.75 points**
- **Task 2.b.** The script properly receives and executes the *medium_square* argument: **0.5 points**
- **Task 2.c.** The script properly receives and executes the *big_square* argument: **0.5 points**
- **Task 3.a.** Permissions in file exam1.py are correct: **0.5 point**
- **Task 3.b.** Permissions in file exam1.py are correct: **0.5 point**
- **Task 3.c.** Permissions in file exam1.py are correct: **0.5 point**

Part 2:

- **Task 1.a.** The function correctly returns the position in the list of the highest value: **0.75 points**
- **Task 1.b.** The function correctly returns the position in the list of the lowest value: **0.75 points**
- **Task 2.a.** The robot has stopped when the wall is closer than 1.5 meter: **0.75 points**
- **Task 2.b.** The robot has turned 90 degrees to his right: **0.75 point**
- **Task 3.a.** The *get_laser_readings* method of the *ExamControl* class works as expected when called: **1 points**
- **Task 3.b.** The *main* method of the *ExamControl* class works as expected when called: **1 points**


 **Only those with an 8 out of 10 will get a certificate**. This means, you have correctly understood the concepts and know how to use them to solve a robotics problem.

Having a 10 out of 10 means that you also know how to apply the  concepts in order to accomplish a task. This should be your goal.
