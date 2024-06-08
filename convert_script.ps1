param (
	[string]$directoryPath = $(throw "-directoryPath is required"),
	[string]$mainFile = $(throw "-mainFile is required"),
	[string]$condaEnv = $(throw "-condaEnv is required")
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
	conda activate $condaEnv
	cd $directoryPath
	pyinstaller $mainFile
	
	# Delete build and dist folders and adjust spec file
	rm $distFolder -r -force
	rm $buildFolder -r -force
	$new = (Get-Content -Path "$root/template.spec")
	$new | Set-Content -Path "$directoryPath/$mainName.spec"

	# rerun Pyinstaller with the new spec file
	pyinstaller "$mainName.spec"
	
	# add the pymzml folder to dist
	$sourceDirectory = "$root/PYMZML/pymzml"
	$destDirectory = "$directoryPath/dist/__main__"
	Copy-Item -Path $sourceDirectory -Recurse -Destination $destDirectory -Container 
}

cd $root

# return DeuteRater.spec back to normal so we can use it again later
$newtext = (Get-Content -Path $specFile -ReadCount 0) -join "`n"
$newtext = $newtext -replace '$mainFile', 'MAINFILE'
$newtext = $newtext -replace '$directoryPath', 'FOLDERPATH'
$newtext = $newtext -replace '$mainName', 'MAINNAME'
$newtext | Set-Content -Path $specFile