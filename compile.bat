@echo off
set CLOSURE=%HOME%\bin\compiler.jar
set JAVA=java
set COFFEE=coffee

set DEBUG_OPTIONS=--formatting PRETTY_PRINT --compilation_level WHITESPACE_ONLY 

%JAVA% -jar %CLOSURE% --js=js/ImageReader.js --js=js/ImageFader.js --js=js/ImagePagination.js --js=js/ImageCaption.js --js=js/Interval.js --js_output_file=min/pd.min.js

%JAVA% -jar %CLOSURE% --js=js/SimpleTheme.js --js_output_file=min/SimpleTheme.min.js
