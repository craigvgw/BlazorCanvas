dotnet restore
dotnet build -c Release --no-restore

rm -rf build

projects=($(ls -1 -- **/*.csproj))
for i in "${projects[@]}"
do
    filename=$(basename -- "$i")    
    filename="${filename%.*}"
    buildPath="build/$filename-t"    
	dotnet publish --configuration Release $i --output $buildPath --no-build --no-restore
    mv $buildPath/wwwroot/ "build/$filename"        
    rm -rf $buildPath

    sed -i -e "s/<base href=\"\/\" \/>/<base href=\"\/BlazorCanvas\/$filename\/\" \/>/g" build/$filename/index.html
done

cp readme.md build/readme.md