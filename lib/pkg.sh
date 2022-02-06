# VladVons@gmail.com


Pkg_Check()
{
    local aName="$1";

    ##dpkg -l | awk '{ print $2, $3 }' | sort | grep -w -m 1 "$aName"
    #dpkg-query -Wf '${Package}\t${Installed-Size}\n'
    dpkg -l $aName 2>&1 | grep ii | awk '{ print $3 }'
    #cat $cFileDpkgFast | grep -w -m 1 "$aName"
}


Pkg_Update()
{
    Log "$0->$FUNCNAME"

    rm /var/lib/dpkg/lock

    apt-get autoremove --yes
    dpkg --configure -a
    apt install --fix-broken --yes

    apt update --yes
    apt dist-upgrade --yes
    #reboot
}


Pkg_Clear()
{
    Log "$0->$FUNCNAME"

    rm /var/cache/apt/archives/lock 2>/dev/null
    apt-get autoremove --yes
    apt-get clean --yes
}


Pkg_FileListInstall()
# install packages listed in file
# ------------------------
{
    local aFile="$1";

    if [ -r $aFile ]; then
        declare -a Files=$(cat $aFile | grep "^[^\#]")

        for File in ${Files[@]}; do
            Installed=$(_PkgCheck $File)
            if [ ! "$Installed" ]; then
                echo.
                echo $File
                apt-get install --yes --no-install-recommends $File
            fi
        done
    else
        Log "Error! Can't read file: $aFile"
    fi
}


Pkg_FileListInstallFast()
{
    local aFile="$1";
    Log "$0->$FUNCNAME($*)"

    #apt-get install --yes --no-install-recommends $(grep -vE "^\s*#" $aFile | tr "\n" " ")
    #grep -vE "^\s*#" $aFile | xargs -n 1 apt-get install --yes --no-install-recommends
    #sed '/^[[:blank:]]*#/d;s/#.*//' $aFile | xargs -n 1 apt-get install --yes --no-install-recommends

    declare -a Items=$(sed '/^[[:blank:]]*#/d;s/#.*//' $aFile)
    for Item in ${Items[@]}; do
      echo "Install apt: $Item ..."
      apt-get install --yes --no-install-recommends $Item
    done
}

Snap_FileListInstall()
{
    local aFile="$1";
    Log "$0->$FUNCNAME($*)"

    sed '/^[[:blank:]]*#/d;s/#.*//' $aFile 2>/dev/null |\
    while read Item; do
      echo "Install snap: $Item ..."
      snap install $Item
    done
}



Pkg_Version()
{
  local aName="$1";
  Log "$0->$FUNCNAME($*)"

  Ver=$(dpkg -s "$aName" | grep -i "version:")
  echo $aName $Ver | grep $aName --color=auto
}


Pkg_RemoveOldKernel()
{
    Log "$0->$FUNCNAME"

    # proxmox
    List=$(dpkg --list | grep -P -o "pve-kernel-\d\S+-pve" | grep -v $(uname -r | grep -P -o ".+\d"))
    printf '%b\n' $List
    apt-get purge $List

    # ubuntu
    List=$(dpkg --list | grep -P -o "linux-image-\d\S+-generic" | grep -v $(uname -r | grep -P -o ".+\d"))
    printf '%b\n' $List
    apt-get purge $List

    apt-get autoremove
}


Pkg_DebUrl()
{
    local aUrl="$1";
    Log "$0->$FUNCNAME($*)"

    File=$(basename $aUrl)
    wget --no-check-certificate $aUrl -O /tmp/$File
    dpkg -i /tmp/$File
    apt install -y -f
    rm /tmp/$File
}


Pkg_RemoveBad()
{
    Log "$0->$FUNCNAME"

    declare -a Files=$(dpkg -l | tail -n +6 | awk '{print $1,$2}' | grep -v "ii" | awk '{print $2}')

    for i in ${Files[@]}; do
        Log "$0->$FUNCNAME, $i"

        apt-get remove --purge --yes $i

        rm /var/lib/dpkg/info/${i}.*
        dpkg --purge --force-remove-reinstreq $i

        if [[ $i != *"linux-image"* ]]; then
            apt-get install --yes $i
        fi

        apt-get autoremove --yes
    done
}


Pkg_RemoveForce()
{
    local aPkg=$1
    Log "$0->$FUNCNAME, $aPkg"

    mv /var/lib/dpkg/info/$aPkg.* /tmp/
    dpkg --remove --force-remove-reinstreq $aPkg
    apt remove --purge $aPkg
}


Pkg_Download()
{
    local aMask=$1
    apt-cache search grub | grep ^${aMask} | awk '{print $1}' | xargs apt download 
}
