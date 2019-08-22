#!/bin/sh

usage () {
    cat <<__EOF__
usage: $(basename $0) [-hlp] [-u user] [-X args] [-d args]
  -h        print this help text
  -l        print list of files to download
  -p        prompt for password
  -u user   download as a different user
  -X args   extra arguments to pass to xargs
  -d args   extra arguments to pass to the download program

__EOF__
}

username=mmarcano22
xargsopts=
prompt=
list=
while getopts hlpu:xX:d: option
do
    case $option in
    h)  usage; exit ;;
    l)  list=yes ;;
    p)  prompt=yes ;;
    u)  prompt=yes; username="$OPTARG" ;;
    X)  xargsopts="$OPTARG" ;;
    d)  download_opts="$OPTARG";;
    ?)  usage; exit 2 ;;
    esac
done

if test -z "$xargsopts"
then
   #no xargs option speficied, we ensure that only one url
   #after the other will be used
   xargsopts='-L 1'
fi

if [ "$prompt" != "yes" ]; then
   # take password (and user) from netrc if no -p option
   if test -f "$HOME/.netrc" -a -r "$HOME/.netrc"
   then
      grep -ir "dataportal.eso.org" "$HOME/.netrc" > /dev/null
      if [ $? -ne 0 ]; then
         #no entry for dataportal.eso.org, user is prompted for password
         echo "A .netrc is available but there is no entry for dataportal.eso.org, add an entry as follows if you want to use it:"
         echo "machine dataportal.eso.org login mmarcano22 password _yourpassword_"
         prompt="yes"
      fi
   else
      prompt="yes"
   fi
fi

if test -n "$prompt" -a -z "$list"
then
    trap 'stty echo 2>/dev/null; echo "Cancelled."; exit 1' INT HUP TERM
    stty -echo 2>/dev/null
    printf 'Password: '
    read password
    echo ''
    stty echo 2>/dev/null
fi

# use a tempfile to which only user has access 
tempfile=`mktemp /tmp/dl.XXXXXXXX 2>/dev/null`
test "$tempfile" -a -f $tempfile || {
    tempfile=/tmp/dl.$$
    ( umask 077 && : >$tempfile )
}
trap 'rm -f $tempfile' EXIT INT HUP TERM

echo "auth_no_challenge=on" > $tempfile
# older OSs do not seem to include the required CA certificates for ESO
echo "check-certificate=off"  >> $tempfile
if [ -n "$prompt" ]; then
   echo "--http-user=$username" >> $tempfile
   echo "--http-password=$password" >> $tempfile

fi
WGETRC=$tempfile; export WGETRC

unset password

if test -n "$list"
then cat
else xargs $xargsopts wget $download_opts 
fi <<'__EOF__'
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.328/ADP.2017-03-30T14:36:08.328.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2016-09-02T01:40:06.103/ADP.2016-09-02T01:40:06.103.log"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.316/ADP.2017-03-30T14:36:08.316.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.304/ADP.2017-03-30T14:36:08.304.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.336/ADP.2017-03-30T14:36:08.336.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.324/ADP.2017-03-30T14:36:08.324.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.312/ADP.2017-03-30T14:36:08.312.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.300/ADP.2017-03-30T14:36:08.300.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.332/ADP.2017-03-30T14:36:08.332.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.299/ADP.2017-03-30T14:36:08.299.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.320/ADP.2017-03-30T14:36:08.320.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.340/ADP.2017-03-30T14:36:08.340.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.295/ADP.2017-03-30T14:36:08.295.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2016-09-02T01:40:06.107/ADP.2016-09-02T01:40:06.107.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.308/ADP.2017-03-30T14:36:08.308.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.317/ADP.2017-03-30T14:36:08.317.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.305/ADP.2017-03-30T14:36:08.305.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.337/ADP.2017-03-30T14:36:08.337.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.325/ADP.2017-03-30T14:36:08.325.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.313/ADP.2017-03-30T14:36:08.313.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.301/ADP.2017-03-30T14:36:08.301.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.333/ADP.2017-03-30T14:36:08.333.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.321/ADP.2017-03-30T14:36:08.321.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.341/ADP.2017-03-30T14:36:08.341.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.296/ADP.2017-03-30T14:36:08.296.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.292/ADP.2017-03-30T14:36:08.292.fits"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/README_493203/README_493203.txt"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.309/ADP.2017-03-30T14:36:08.309.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.329/ADP.2017-03-30T14:36:08.329.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2016-09-02T01:40:06.104/ADP.2016-09-02T01:40:06.104.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.306/ADP.2017-03-30T14:36:08.306.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.338/ADP.2017-03-30T14:36:08.338.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.326/ADP.2017-03-30T14:36:08.326.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2016-09-02T01:40:06.101/ADP.2016-09-02T01:40:06.101.fits"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.314/ADP.2017-03-30T14:36:08.314.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.302/ADP.2017-03-30T14:36:08.302.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.334/ADP.2017-03-30T14:36:08.334.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.322/ADP.2017-03-30T14:36:08.322.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.310/ADP.2017-03-30T14:36:08.310.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.330/ADP.2017-03-30T14:36:08.330.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.297/ADP.2017-03-30T14:36:08.297.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.293/ADP.2017-03-30T14:36:08.293.fits"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2016-09-02T01:40:06.105/ADP.2016-09-02T01:40:06.105.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.318/ADP.2017-03-30T14:36:08.318.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.339/ADP.2017-03-30T14:36:08.339.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.327/ADP.2017-03-30T14:36:08.327.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2016-09-02T01:40:06.102/ADP.2016-09-02T01:40:06.102.fits"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.315/ADP.2017-03-30T14:36:08.315.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.303/ADP.2017-03-30T14:36:08.303.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.335/ADP.2017-03-30T14:36:08.335.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.323/ADP.2017-03-30T14:36:08.323.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.311/ADP.2017-03-30T14:36:08.311.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.331/ADP.2017-03-30T14:36:08.331.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.298/ADP.2017-03-30T14:36:08.298.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.294/ADP.2017-03-30T14:36:08.294.log"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2016-09-02T01:40:06.106/ADP.2016-09-02T01:40:06.106.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.319/ADP.2017-03-30T14:36:08.319.png"
"https://dataportal.eso.org/dataPortal/api/requests/mmarcano22/493203/PHASE3/ADP.2017-03-30T14:36:08.307/ADP.2017-03-30T14:36:08.307.png"

__EOF__
