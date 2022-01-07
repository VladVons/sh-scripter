TestEx()
{
    mpd --version | grep cue

    ExecM "cat /proc/asound/cards"
    ExecM "cat /proc/asound/card*/codec* | grep Codec"
    ExecM "cat /proc/asound/modules"

    #ExecM "rmmod snd-hda-intel"
    #ExecM "modprobe snd-hda-intel model=auto"

    #ExecM "alsactl init 0"
}
