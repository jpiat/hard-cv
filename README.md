hard-cv
=======

A repository of IPs for hardware computer vision (FPGA)

This project aims at creating an open source library of synthesizable VHDL design for computer vision. 
The project is divided into different operators set :

- bus : contains bus peripheral commonly used (fifo, registers ...)
- com : defines protocol for communication outside the FPGA
- conf : defines configuration set for camera and display
- image : contains basic building blocks for image processing tasks
	- image/filter : image filtering components (gaussian, sobel, thresholding, erode, dilate ...)
	- image/feature : feature detection and processing in images (harris, brief descriptor/correlator,...)
	- image/classifier : classification algorithm (color classifier)
	- image/blob : blob detection algorithm
	- image/graphic : drawing functions
- interface : component to interface FPGA to sensors (camera), display and processor (spi, memory-bus, i2c)
- primitive : components to instantiate FPGA resources (memory, multipliers)
- utils : all application agnostic components (fifo, counter, registers, delay ...)


These IPs are free to use, don't hesitate to contact me for any problem.


Projects using this library :
- logi-boards : a family of psartan6 based board that connect to raspberry-pi, beaglebone.
