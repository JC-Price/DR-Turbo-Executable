param (
	[string]$directoryPath = $(throw "-directoryPath is required"),
	[string]$mainFile = $(throw "-mainFile is required")
	# [string]$condaEnv = $(throw "-condaEnv is required")
)
$root = $PSScriptRoot
Write-Host "Preparing to convert DeuteRater into an executable from this directory: $directoryPath`nAnd this main_gui: $mainFile`n"

# replace items in spec value with appropriate paths and file names
$specFile = "$PSScriptRoot\template.spec"
$mainName = $mainFile -replace '.py', ''

# use the paramters above to adjust spec file
$text = (Get-Content -Path $specFile -ReadCount 0) -join "`n"
$text = $text -replace 'MAINFILE', $mainFile
$text = $text -replace 'FOLDERPATH', $directoryPath
$text = $text -replace 'MAINNAME', $mainName
$text | Set-Content -Path $specFile

# now we want to use pyinstaller
# first check if there are existing [$distFolder] or [$buildFolder] directories
# if they do exist, we'll ask the user to delete them before moving forward

$distFolder = "$directoryPath/dist"
$buildFolder = "$directoryPath/build"
"Checking to see if [$distFolder] or [$buildFolder] folders exist"
if (Test-Path -Path $distFolder) {
	"Please delete any existing dist or build folders related to pyinstaller`n"
	Remove-Item $distFolder -r -force
	Remove-Item $buildFolder -r -force
	Remove-Item "$directoryPath/$mainName.spec"
	# exit
} elseif (Test-Path -Path $buildFolder) {
	"Please delete any existing dist or build folders related to pyinstaller`n"
	Remove-Item $distFolder -r -force
	Remove-Item $buildFolder -r -force
	Remove-Item "$directoryPath/$mainName.spec"
	# exit
}
# else {
#	"Running Pyinstaller"
#	# conda activate $condaEnv
#	Set-Location $directoryPath
#	pyinstaller $mainFile
#
#	# Delete build and dist folders and adjust spec file
#	Remove-Item $distFolder -r -force
#	Remove-Item $buildFolder -r -force
#	$new = (Get-Content -Path "$root/template.spec")
#	$new | Set-Content -Path "$directoryPath/$mainName.spec"
#
#	# rerun Pyinstaller with the new spec file
#	pyinstaller "$mainName.spec"
#
#	# add the pymzml folder to dist
#	$sourceDirectory = "$root/PYMZML/pymzml"
#	$destDirectory = "$directoryPath/dist/__main__"
#	Copy-Item -Path $sourceDirectory -Recurse -Destination $destDirectory -Container
#}

"Running Pyinstaller and activating conda environment"
# conda activate $condaEnv
Set-Location $directoryPath
pyinstaller $mainFile

# Delete build and dist folders and adjust spec file
Remove-Item $distFolder -r -force
Remove-Item $buildFolder -r -force
$new = (Get-Content -Path "$root/template.spec")
$new | Set-Content -Path "$directoryPath/$mainName.spec"

# rerun Pyinstaller with the new spec file
pyinstaller "$mainName.spec"

# add the pymzml folder to dist
$sourceDirectory = "$root/PYMZML/pymzml"
$destDirectory = "$directoryPath/dist/DeuteRater-v6"
Copy-Item -Path $sourceDirectory -Recurse -Destination $destDirectory -Container

# add obo files used with pymzml
$sourceDirectory = "$root/PYMZML/obo"
Copy-Item -Path $sourceDirectory -Recurse -Destination $destDirectory -Container

Set-Location $root
# conda deactivate $condaEnv
