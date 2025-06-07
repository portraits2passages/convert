@echo off
setlocal enabledelayedexpansion

REM Check if input and output directories are provided as parameters
if "%~1"=="" (
    echo Usage: convert_videos.bat ^"<base_input_dir^" ^"<base_output_dir^"
    exit /b 1
)

REM Set the base input and output directories from parameters
set "base_input_dir=%~1"
set "base_output_dir=%~2"

echo Base input directory: "%base_input_dir%"
echo Base output directory: "%base_output_dir%"

REM Start the conversion process from the base input directory
echo Starting conversion process from base input directory...
call :convert_videos "%base_input_dir%"

echo Conversion complete.
pause
exit

REM Function definitions

REM Function to convert videos in a given directory
:convert_videos
echo Processing directory: "%~1"
for %%f in ("%~1\*.mp4") do (
    set "input_file=%%~f"
    set "full_path=%%~dpf"
    REM Correctly calculate the relative path
    set "relative_path=!full_path:%base_input_dir%=!"
    set "output_dir=%base_output_dir%!relative_path!"
    set "output_file=!output_dir!%%~nxf"

    REM Create output directory if it doesn't exist
    if not exist "!output_dir!" (
        echo Creating output directory: "!output_dir!"
        mkdir "!output_dir!"
    )

    REM Convert the video to 1080p
    echo Converting video: "!input_file!" to "!output_file!" in "!output_dir!"
    ffmpeg -n -i "!input_file!" -vf "scale=1920:1080" "!output_file!"
)

REM Recursively process all sub-folders
for /d %%d in ("%~1\*") do (
    echo Entering sub-directory: "%%d"
    call :convert_videos "%%d"
)

REM End of the convert_videos function
exit /b
