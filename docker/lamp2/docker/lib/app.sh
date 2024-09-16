# Created: 2022.11.11
# Author: Vladimir Vons <VladVons@gmail.com>

app_CopyFile()
{
    local aVer=$1;
    log_Print "$0->$FUNCNAME($*)($PWD)"

    Dir="f_static$aVer"
    if [ -d $Dir ]; then
        log_Print "$0->$FUNCNAME, $Dir"
        #cp -rb $Dir/* / 2>/dev/null
        sys_ExecM "cp -rf $Dir/* / 2>/dev/null"
    fi

    Dir="f_dynamic$aVer"
    if [ -d $Dir ]; then
        log_Print "$0->$FUNCNAME, $Dir"

        find $Dir -type f |\
        while read Item; do
            FileDst=$(echo $Item | sed -e "s|${Dir}||")
            mkdir -p $(dirname $FileDst)

            #(echo "cat <<EOF" ; cat $Item ; echo EOF ) | sh
            cat $Item | envsubst > $FileDst
        done
    fi

    Dir="f_arch$aVer"
    if [ -d $Dir ]; then
        log_Print "$0->$FUNCNAME, $Dir"

        ls $Dir/*.zip $Dir/*.gz 2>/dev/null |\
        while read Item; do
            Inf=${Item}.inf
            if [ -f $Inf ]; then
               source $Inf

               log_Print "unpack $Item to $dir"
               mkdir -p $dir

               if [[ "$Item" == *.tar.gz ]]; then
                   tar -xzf $Item -C $dir
               elif [[ "$Item" == *.zip ]]; then
                   unzip $Item -d $dir
               else
                   log_Print "Unsupported archive $Item"
               fi

               unset dir
            fi
        done

    fi

}
