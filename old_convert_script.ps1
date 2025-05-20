# specify what options are required for the program to run
param (
	[string]$directoryPath = $(throw "-directoryPath is required"),
	[string]$mainFile = $(throw "-mainFile is required")
)

$root = $PSScriptRoot

# first check if paths are valid
if (-Not (Test-Path -Path $directoryPath)) {
    $(throw "-directoryPath does not exist")
    exit
}
if (-Not (Test-Path -Path "$directoryPath\$mainFile")) {
    $(throw "-mainFile does not exist")
    exit
}

Write-Host "Preparing to convert DeuteRater into an executable from this directory: $directoryPath`nAnd this main_gui: $mainFile`n"

# replace items in spec value with appropriate paths and file names
$specFile = "$PSScriptRoot\template.spec"
Copy-Item -Path $specFile -Destination "$PSScriptRoot\altered-template.spec"
$specFileCopy = "$PSScriptRoot\altered-template.spec"
$mainName = $mainFile -replace '.py', ''

# use the paramters above to adjust spec file
$text = (Get-Content -Path $specFileCopy -ReadCount 0) -join "`n"
$text = $text -replace 'MAINFILE', $mainFile
$text = $text -replace 'FOLDERPATH', $directoryPath
$text = $text -replace 'MAINNAME', $mainName
$text | Set-Content -Path $specFileCopy

# now we want to use pyinstaller
# first check if there are existing [$distFolder] or [$buildFolder] directories
# if they do exist, we'll ask the user to delete them before moving forward

$distFolder = "$directoryPath/dist"
$buildFolder = "$directoryPath/build"
"Checking to see if dist or build folders exist"
if (Test-Path -Path $distFolder) {
	"Please delete any existing dist or build folders related to pyinstaller`n"
	# rm $distFolder -r -force
	# rm $buildFolder -r -force
	# rm "$directoryPath/$mainName.spec"
	exit
} elseif (Test-Path -Path $buildFolder) {
	"Please delete any existing dist or build folders related to pyinstaller`n"
	# rm $distFolder -r -force
	# rm $buildFolder -r -force
	# rm "$directoryPath/$mainName.spec"
	exit
} else {
	"Running Pyinstaller"
	Set-Location $directoryPath
	pyinstaller $mainFile
	
	# Delete build and dist folders and adjust spec file
	try
	{
		Remove-Item $distFolder -r -force
		Remove-Item $buildFolder -r -force
	}
	catch
	{
		"Error removing dist and build folders. Likely an error with pyinstaller."
		exit
	}

	$new = Get-Content -Path $specFileCopy
	$new | Set-Content -Path "$directoryPath/$mainName.spec"

	# rerun Pyinstaller with the new spec file
	pyinstaller "$mainName.spec"
	
	# add the pymzml folder to dist
	$sourceDirectory = "$root/PYMZML/pymzml"
	$destDirectory = "$directoryPath/dist/__main__"
	Copy-Item -Path $sourceDirectory -Recurse -Destination $destDirectory -Container 
}

Set-Location $root
