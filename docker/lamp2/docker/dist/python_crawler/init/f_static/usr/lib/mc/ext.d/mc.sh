#- VladVons
#- 2024.09.15

zip_p()
{
  aSrcDir="$1"; aSrcFile="$2"; aDstDir="$3";

  if [ "$aSrcFile" = ".." ]; then
    aSrcFile=$(basename "$aSrcDir")
    zip -r "$aDstDir/$aSrcFile" .
  elif [ -d "$aSrcFile" ]; then
    zip -r "$aDstDir/$aSrcFile" $aSrcFile
  else
    zip "$aDstDir/$aSrcFile.zip" $aSrcFile
  fi
}

tar_p()
{
  aSrcDir="$1"; aSrcFile="$2"; aDstDir="$3";

  if [ "$aSrcFile" = ".." ]; then
    aSrcFile=$(basename "$aSrcDir")
    tar -cf - . > "$aDstDir/$aSrcFile.tar"
  elif [ -d "$aSrcFile" ]; then
    tar -cf - $aSrcFile > "$aDstDir/$aSrcFile.tar"
  else
    tar -cf - $aSrcFile > "$aDstDir/$aSrcFile.tar"
  fi
}


case $1 in
    tar_p)    "$@" ;;
    zip_p)    "$@" ;;
esac
