# DR-Turbo-Executable - Ben Driggs - 2025
A tool to help streamline converting DeuteRater into a distributable executable.

## Instructions
I typically ran the convert_script.ps1 in a command prompt window with the appropriate DeuteRater environment activated. 
If you don't have Anaconda connected to your command prompt, you'll need to initalize it before you can activate any environments.
You may need to look up how to do this if it changes in the future, but I did this by using this command in my command prompt:

conda init cmd.exe

You can then activate the proper DeuteRater environment in you command prompt.

Make copies of the template.spec, convert_script.ps1, and the PYMZML folder and place them into the main directory of the 
DeuteRater directory. You will run the convert_script.ps1 in the DeuteRater project main directory with the proper conda 
environemnt activated. 

In the template.spec file, will see a few places where there is a path specified. Make sure to update these to reflect the 
paths on your machine. your version of DeuteRater is located. Then, copy the template.spec file into the DeuteRater 
directory. As the name implies, this is a template pyinstaller will use during while creating the executable. 

You will also need to copy the PYMZML folder in this project into the DeuteRater directory. This folder contains necessary 
dependencies for PYMZML that pyinstaller struggles to find when creating the executable. If we ever upgrade to a newer version of 
PYMZML, this step might change.

command.txt has an example of how to run the convert_script.ps1 file. Changing the ExecutionPolicy to Bypass allows the program 
to run without Windows flagging and preventing it from running. The -File option should be the path to where you have the 
convert_script.ps1 stored. The -directoryPath option should contain the directory that has all the DeuteRater code. Finally, 
the -mainFile option should be the name of the main python file that runs DeuteRater.

If the paths provided are valid, convert_script.ps1 will proceed to run the pyinstaller process of turning DeuteRater into 
an executable. Once finished, inside the dist directory, you'll find a folder than contains everything related to the executable. 
You can copy this folder and move it somewhere else to test it out. In this folder, there will be an exe file with the DeuteRater icon. 
This will be the actually executable program, and it needs to stay inside the folder that contains all the necessary dependencies. 
You can create a shortcut to your desktop if you want quick access to the program.

## Tips, Tricks, and Other Information
***PYMZML*** - the version of PYMZML we are currently using doesn't work well with pyinstaller.

***resources*** - contains the DeuteRater logo icon to make the executable a little more pretty.

***main_gui.py and run_script.py*** - these were my first attempts at making this whole process accessible through a gui/python interface. 
This would be nice, but I ran into some permission issues and had to focus my attention on other things. Feel free to tinker 
with this if you have time, but I think the CLI version works just fine.

If you look at the convert_script.ps1 file, you'll notice that it runs pyinstaller twice. This is how Bradley Naylor showed me 
how to do it, and it's mainly because of the complications with PYMZML and needing to copy the folder with dependencies into 
the right location.

Here are the instructions Brad gave me if you want to reference them:

https://docs.google.com/presentation/d/1dGnPAlZuKiIgetzoSdg7SSScInFWnMXy/edit?usp=sharing&ouid=115192763093728586861&rtpof=true&sd=true