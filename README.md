# FD-TD

Matlab complete application for numerically solve Finite-Difference-Time-Domain. User inputs the environment using a programmatic config file where objects can be put as commands or loaded from images.
The application generates a video for the simulation.

Demo videos at:
https://www.youtube.com/watch?v=THjsEf_L_d0
https://www.youtube.com/watch?v=bYd_2QMkO7o
https://www.youtube.com/watch?v=oS9QY_khZVI
https://www.youtube.com/watch?v=A5gRagd0pvY

## Software

Matlab

## Hardware

## Screen-shoots

![Optical fiber simulation](/doc/img1.png?raw=true "Sample image 1")
![Anti-reflex principle demonstration](/doc/img2.png?raw=true "Sample image 2")
![Wavefront sensor principle demonstration](/doc/img3.png?raw=true "Sample image 3")
![Complex optical circuit (optical fiber and wave guide)](/doc/img4.png?raw=true "Sample image 4")

## Instructions

1 - Configure your environment using the file configSimulation.m

1.1 - Add a new item in the main switch command with the name of your simulation

1.2 - Code your simulation (see examples)

2 - Setup parameters in run2D_new_gpu.m

2.1 - Change the name of the simulation in the section with comment "simulation configuration" (again, see example) 

2.2 - Optionally, change the running method between CPU or GPU in the comment section cpu/gpu 

2.3 - Setup the rest (video file, quiver, etc...)

3 - run the file run2D_new_gpu.m