
#--- VladVons
hg()
{
  aCmd=$1
  history | awk '{$1=""; print $0}' | grep -v "hg $aCmd" | sort -u | grep --color=auto $aCmd
}
