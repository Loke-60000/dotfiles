
# Adaptive GPU Fan Control Setup

Set up an adaptive GPU fan control script on both Ubuntu and Arch Linux.

## Prerequisites

Before you begin, ensure you have the following installed:

- **NVIDIA drivers**
- **nvidia-settings**
- **Xvfb** (for creating a virtual display)

### Ubuntu

```bash
sudo apt update
sudo apt install nvidia-driver-<version> nvidia-settings xserver-xorg-video-nvidia xvfb -y
```

### Arch Linux

```bash
sudo pacman -Syu
sudo pacman -S nvidia nvidia-settings xorg-server-xvfb
```

## Step 1: Create the Fan Control Script

1. **Create the script:**

   ```bash
   sudo nano /usr/local/bin/set_gpu_fan.sh
   ```

2. **Add the following content:**

   ```bash
   #!/bin/bash

   LOGFILE=/var/log/set_gpu_fan.log

   echo "Starting Xvfb..." >> $LOGFILE

   # Check if Xvfb is already running, if not, start it
   if ! pgrep Xvfb > /dev/null
   then
       /usr/bin/Xvfb :99 -screen 0 640x480x24 &
       sleep 2  # Give Xvfb some time to start
   fi

   # Set the DISPLAY variable
   export DISPLAY=:99

   # Loop through all GPUs and adjust fan speed based on temperature
   GPU_COUNT=$(nvidia-smi --query-gpu=count --format=csv,noheader,nounits)
   
   # Define temperature thresholds and corresponding fan speeds
   TEMP_LOW=40   # Below this temperature, the fan will run at 30%
   TEMP_MED=60   # Between TEMP_LOW and TEMP_MED, the fan will run at 50%
   TEMP_HIGH=80  # Above this temperature, the fan will run at 70%
   TEMP_CRIT=90  # Above this temperature, the fan will run at 100%

   while true; do
       for (( i=0; i<$GPU_COUNT; i++ ))
       do
           TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits -i $i)
           echo "GPU $i temperature: $TEMP" >> $LOGFILE

           if [ $TEMP -lt $TEMP_LOW ]; then
               FAN_SPEED=30
           elif [ $TEMP -lt $TEMP_MED ]; then
               FAN_SPEED=50
           elif [ $TEMP -lt $TEMP_HIGH ]; then
               FAN_SPEED=70
           else
               FAN_SPEED=100
           fi

           echo "Setting fan speed to $FAN_SPEED% on GPU $i" >> $LOGFILE
           nvidia-settings -a "[gpu:$i]/GPUFanControlState=1" -a "[fan:$i]/GPUTargetFanSpeed=$FAN_SPEED" >> $LOGFILE 2>&1
       done
       sleep 10  # Adjust fan speed every 10 seconds
   done
   ```

3. **Save and exit the script:**

   Press `CTRL+O` to save, then `CTRL+X` to exit.

4. **Make the script executable:**

   ```bash
   sudo chmod +x /usr/local/bin/set_gpu_fan.sh
   ```

## Step 2: Create a Systemd Service

1. **Create the systemd service file:**

   ```bash
   sudo nano /etc/systemd/system/set_gpu_fan.service
   ```

2. **Add the following content:**

   ```ini
   [Unit]
   Description=Adaptive GPU Fan Control
   After=network.target

   [Service]
   ExecStart=/usr/local/bin/set_gpu_fan.sh
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

3. **Save and exit the service file:**

   Press `CTRL+O` to save, then `CTRL+X` to exit.

## Step 3: Enable and Start the Service

1. **Reload the systemd daemon:**

   ```bash
   sudo systemctl daemon-reload
   ```

2. **Enable the service to start on boot:**

   ```bash
   sudo systemctl enable set_gpu_fan.service
   ```

3. **Start the service:**

   ```bash
   sudo systemctl start set_gpu_fan.service
   ```

4. **Check the status of the service:**

   ```bash
   sudo systemctl status set_gpu_fan.service
   ```

5. **Monitor the log file:**

   ```bash
   sudo tail -f /var/log/set_gpu_fan.log
   ```

## Step 4: Verify the Setup

1. **Reboot the system:**

   ```bash
   sudo reboot
   ```

2. **After rebooting, verify that the service is running and the fan speeds are being adjusted:**

   ```bash
   nvidia-smi
   ```

You should see that the fan speeds are adjusted according to the temperature thresholds specified in the script.

## Customization

- **Adjust the temperature thresholds and fan speeds in the script according to your needs.**
- **Modify the sleep interval in the script if you want the fan speed to adjust more or less frequently.**

This setup ensures that your GPU fans are managed efficiently based on the temperature, providing a balance between cooling performance and noise levels.
