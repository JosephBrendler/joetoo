#!/bin/bash
# make_sources.sh (formerly mkinitramfs.sh) -- set up my custom initramfs
# Joe Brendler - 9 September 2014
#    for version history and "credits", see the accompanying "historical_notes" file
#
# To Do -- finish migrating to standardized "merged-usr" layout
#          (/bin, /sbin, and /usr/sbin all link to /usr/bin now)
#          (still nned to link /lib to /usr/lib and /lib64 to /usr/lib64) ***
#          (*** all libs currently link to /lib)

# --- Define local variables -----------------------------------

# the GLOBALS file identifies the BUILD, SOURCES_DIR (e.g. /usr/src/initramfs),
#   and the MAKE_DIR (parent dir of this script)
source GLOBALS
source ${SCRIPT_HEADER_DIR}/script_header_brendlefly
# script header will over-ride BUILD, but globals must be sourced 1st to get _DIRs
BUILD="${KERNEL_VERSION}-${DATE_STAMP}"

VERBOSE=$TRUE
#VERBOSE=$FALSE
verbosity=2

# identify config files
[[ -e ${MAKE_DIR}/init.conf ]] && CONF_DIR=${MAKE_DIR}
[[ -e /etc/mkinitramfs/init.conf ]] && CONF_DIR="/etc/mkinitramfs"
[[ -e ${MAKE_DIR}/mkinitramfs.conf ]] && MAKE_CONF_DIR=${MAKE_DIR}
[[ -e /etc/mkinitramfs/mkinitramfs.conf ]] && MAKE_CONF_DIR="/etc/mkinitramfs"

# override (ROTATE and verbosity) variables with mkinitramfs.conf file
source ${MAKE_CONF_DIR}/mkinitramfs.conf

# define lists of files that need to be copied
config_file="${CONF_DIR}/init.conf"
admin_files="README LICENSE"
other_content_src=("/usr/local/sbin/script_header_brendlefly" "${MAKE_DIR}/etc/lvm/lvm.conf"        "${MAKE_DIR}/etc/modules")
other_content_dest=("${SOURCES_DIR}/"                         "${SOURCES_DIR}/etc/lvm/"  "${SOURCES_DIR}/etc/")

# initialize list of executables
executables=()

# initialize list of dependencies of executables
dependencies=()

#   link everything in busybox, except commands we do NOT want busybox to run --
#   modprobe-->kmod, blkid, e2fsck, find, findfs, fsck, (fsck.ext2, fsck.ext3, fsck.ext4), and of course our own init
busybox_link_list="\
    [ [[ acpid addgroup adduser adjtimex arp arping ash awk base64 basename bb bbsh blockdev \
    brctl bunzip2 bzcat bzip2 cal cat catv chat chattr chgrp chmod chown chpasswd chpst chroot chrt \
    chvt cksum clear cmp comm conspy cp cpio crond cryptpw cttyhack cut date dd deallocvt delgroup \
    deluser depmod devmem df dhcprelay diff dirname dmesg dnsdomainname dos2unix du dumpkmap \
    dumpleases echo ed egrep eject env envdir envuidgid ether-wake expand expr false fatattr fbset \
    fdflush fdformat fdisk fgconsole fgrep flock free freeramdisk fstrim fsync ftpd \
    fuser getopt getty ginit grep groups gunzip gzip halt hd hdparm head hexdump hostname httpd \
    hwclock id ifconfig ifdown ifenslave ifplugd ifup insmod install ionice iostat ip ipaddr \
    ipcrm ipcs iplink iproute iprule iptunnel kbd_mode kill killall killall5 last less linux32 \
    linux64 linuxrc ln loadfont loadkmap login losetup lpq lpr ls lsattr lsmod lsof lspci lsusb \
    lzcat lzma lzop lzopcat makedevs man md5sum mdev mesg microcom mkdir mkdosfs mke2fs mkfifo \
    mkfs.ext2 mkfs.vfat mknod mkpasswd mkswap mktemp modinfo more mount mountpoint mpstat mt \
    mv nameif nanddump nandwrite nbd-client nc netstat nice nmeter nohup nslookup ntpd openvt passwd \
    patch pgrep pidof ping pipe_progress pivot_root pkill pmap popmaildir poweroff powertop printenv \
    printf ps pscan pstree pwd pwdx raidautorun rdate readahead readlink realpath reboot renice reset \
    resize rev rm rmdir rmmod route rtcwake runlevel rx script scriptreplay sed sendmail seq setarch \
    setconsole setfont setkeycodes setlogcons setserial setsid setuidgid sh sha1sum sha256sum sha3sum \
    sha512sum showkey shuf sleep softlimit sort split start-stop-daemon stat strings stty su sum \
    swapoff swapon switch_root sync sysctl tac tail tar tee telnet telnetd test tftp tftpd time \
    timeout top touch tr traceroute true tty ttysize tunctl ubiattach ubidetach ubimkvol ubirmvol \
    ubirsvol ubiupdatevol udhcpc udhcpd umount uname unexpand uniq unix2dos unlink unlzma unlzop unxz \
    unzip uptime users usleep vconfig vi vlock volname wall watch watchdog wc wget which who whoami \
    whois xargs xz xzcat yes zcat zcip"

# define lists of links that need to be created in /sbin
#   references to lvm
lvm_link_list="\
    lvchange lvconvert lvcreate lvdisplay lvextend lvmchange lvmconfig \
    lvmdiskscan lvmsadc lvmsar lvreduce lvremove lvrename lvresize \
    lvs lvscan pvchange pvck pvcreate pvdisplay pvmove pvremove \
    pvs vgcfgbackup vgcfgrestore vgchange vgck vgconvert vgcreate \
    vgdisplay vgexport vgextend vgimport vgimportclone vgmerge vgmknodes \
    vgreduce vgremove vgrename vgs vgscan vgsplit"

#   references to e2fsck
e2fsck_link_list="fsck fsck.ext2 fsck.ext3 fsck.ext4"

# use this set of arrays to define other links that need to be created
# in the associated dirs (each "column" is dir, target, link-name)

#   initialize the arrays with values associated with /
other_link_dir=(    "/"     "/"      )
other_link_target=( "lib"   "init"   )
other_link_name=(   "lib64" "linuxrc")

# note 27 Dec 24 - w merged-usr all executables are now in /usr/bin
#   add to the arrays values associated with /bin/ (link relative to target /usr/bin in ../../init)
other_link_dir+=(    "/bin/"   )
other_link_target+=( "../../init" )
other_link_name+=(   "init"    )

#   add to the arrays values associated with /sbin/ - used to link more from /bin /sbin /usr/ssbin, but w merged-usr; dont need
other_link_dir+=(    "/sbin/"   )
other_link_target+=( "kmod"     )
other_link_name+=(   "modprobe" )

#   add to the arrays values associated with /usr/
other_link_dir+=(    "/usr/"  "/usr/")
other_link_target+=( "../lib" "../lib")
other_link_name+=(   "lib"    "lib64")

#   add to the arrays values associated with /usr/bin/
# find is excluded from busybox and provided by gfind
other_link_dir+=(    "/usr/bin/" )
other_link_target+=( "gfind" )
other_link_name+=(   "find" )

#   add to the arrays values associated with /dev/
other_link_dir+=(    "/dev/vc/"   )
other_link_target+=( "../console" )
other_link_name+=(   "0"          )

#---[ functions ]-----------------------------------------------


load_executables()
{
  executables=();  i=0
  while read line
  do
    candidate=$(echo $line)
    if [[ ! "${candidate}" == "" && ! "${candidate:0:1}" == "#" ]]
    then
      target=$(which ${candidate})
      executables+=("${target}")
      d_message "$i: $candidate   which is ${target}   executables[$i] ${executables[$i]}" 3
      let i++
    fi
  done < ${MAKE_DIR}/init_executables
}

list_executables()
{
  for ((i=0; i<${#executables[$@]}; i++))
  do
    [ ! -z ${executables[$i]} ] && echo "${executables[$i]}"
  done
}

dump_executables()
{
  count=0
  for ((i=0; i<${#executables[$@]}; i++))
  do
    [ ! -z ${executables[$i]} ] && message "$i: ${executables[$i]}" && let count++
  done
  message "dumped ${count} executables"
}

display_config()
{
  d_message "SOURCES_DIR: ${SOURCES_DIR}" 2
  d_message "MAKE_DIR: ${MAKE_DIR}" 2
  d_message_n "executables: [ " 2
  for ((i=0; i<${#executables[@]}; i++))
  do
    d_echo -n "${executables[$i]} " 2
  done
  d_echo "]" 2
}

check_for_parts()
{
  PARTSTRING=""
  #look for lvm and cryptsetup, and if not found, ask if user wants to install them
  d_message_n "Finding lvm..." 1
  if [ ! -e /sbin/lvm ]
  then
    d_right_status 1 1
    PARTSTRING+=" sys-fs/lvm2"
  else
    d_right_status 0 1
  fi

  d_message_n "Finding cryptsetup..." 1
  if [ ! -e /sbin/cryptsetup ]
  then
    d_right_status 1 1
    PARTSTRING+=" sys-fs/cryptsetup"
  else
    d_right_status 0 1
  fi

  d_message_n "Finding cpio..." 1
  if [ ! -e /bin/cpio ]
  then
    d_right_status 1 1
    PARTSTRING+=" app-arch/cpio"
  else
   d_right_status 0 1
  fi

  d_message_n "Finding grub..." 1
  if [ ! -e /usr/sbin/grub-install ]
  then
    d_right_status 1 1
    PARTSTRING+=" sys-boot/grub"
  else
    d_right_status 0 1
  fi

  # if splash is requested, check for it
  if [ "${init_splash}" == "yes" ]
  then
    d_message_n "Finding splashutils..." 1
    if [ ! -e /sbin/fbcondecor_helper ]
    then
      d_right_status 1 1
      PARTSTRING+=" media-gfx/splashutils"
    else
      d_right_status 0 1
    fi
  else
    d_message "Skipping check for splashutils... (not requested)" 1
  fi

  # if missing parts are identified, confirm user wants to emerge them, the do so
  if [ ! -z "${PARTSTRING}" ]
  then
    answer="z"
    E_message "Necessary components appear to be missing [${BRon}${PARTSTRING} ${BYon}]."
    prompt "${BRon}*${BYon} Do you want to install them?${Boff}"
    if [[ "$answer" == "y" ]]
    then
      emerge -av ${PARTSTRING}
    else
      exit 1
    fi
  fi
}

copy_parts()
{
  d_message "Copying necessary executable files..." 1
# Maybe future TODO - use progress meter if not $VERBOSE
  # update 27 Dec 24 -- merged-usr layout; everything goes in /usr/bin now

  #copy /bin executable parts
  for part in ${executables[@]}
  do
    # find the actual executable and copy it to the merged-usr layout
    copy_one_part "${part}" "${SOURCES_DIR}/usr/bin/"
  done

  # copy splash parts, if needed
  if [ "${init_splash}" == "yes" ]
  then
    copy_one_part "/sbin/fbcondecor_helper" "${SOURCES_DIR}/usr/bin/"
  else
    d_message "Skipping copy for /sbin/fbcondecor_helper... (splash not requested)" 2
  fi
  copy_one_part "./init" "${SOURCES_DIR}/"

  # copy config file
  copy_one_part "${config_file}" "${SOURCES_DIR}/"

  # copy admin files
  d_message "Copying necessary admin files..." 1
  for i in $admin_files
  do
    copy_one_part "${MAKE_DIR}/$i" "${SOURCES_DIR}/"
  done

  # copy other required content
  d_message "Copying other required content ..." 1
  for ((i=0; i<${#other_content_src[@]}; i++))
  do
    copy_one_part "${other_content_src[i]}" "${other_content_dest[i]}"
  done
  if [ "${init_splash}" == "yes" ]
  then
    copy_one_part "${MAKE_DIR}/etc/initrd.splash" "${SOURCES_DIR}/etc/"
    copy_one_part "${MAKE_DIR}/etc/splash" "${SOURCES_DIR}/etc/"
  else
    d_message "Skipping copy for splash files in /etc/ ... (splash not requested)" 2
  fi
}

copy_one_part()
{
  d_message_n "Copying [ $1 ] to [ $2 ]..." 2
  if [[ $verbosity -ge 3 ]]
  then
    cp -av $1 $2 ; d_right_status $? 2
  else
    cp -a $1 $2 ; d_right_status $? 2
  fi
}

create_links()
{
  old_pwd="$(pwd)"
  # create symlinks - updated 27 Dec 24 with merged-usr layout; everything goes in /usr/bin
  d_message "Creating busybox links in initramfs/bin/ ..." 1
  cd ${SOURCES_DIR}/usr/bin/
  for i in $busybox_link_list
  do
    d_message_n "Linking:   ${LBon}$i${Boff} --> ${BGon}busybox${Boff} ..." 2
    ln -s busybox "$i"
    d_right_status $? 2
  done

  # create symlinks in /sbin - updated 27 Dec 24 with merged-usr layout; everything goes in /usr/bin
  d_message "Creating lvm2 links in initramfs/sbin/ ..." 1
  cd ${SOURCES_DIR}/usr/bin/
  for i in $lvm_link_list
  do
    d_message_n "Linking:   ${LBon}$i${Boff} --> ${BGon}lvm${Boff} ..." 2
    ln -s lvm "$i"
    d_right_status $? 2
  done
  for i in $e2fsck_link_list
  do
    d_message_n "Linking:   ${LBon}$i${Boff} --> ${BGon}e2fsck${Boff} ..." 2
    ln -s e2fsck "$i"
    d_right_status $? 2
  done
  #splash_helper -> //sbin/fbcondecor_helper - updated 27 Dec 24 with merged-usr layout; everything goes in /usr/bin
  if [ "${init_splash}" == "yes" ]
  then
    d_message_n "Linking:   ${LBon}splash_helper${Boff} --> ${BGon}//sbin/fbcondecor_helper${Boff} ..." 2
    ln -s //usr/bin/fbcondecor_helper splash_helper
    d_right_status $? 2
  else
    d_message "Skipping linking for splash... (not requested)" 2
  fi

  # create links to other executables in associated dirs, using array set
  d_message "Creating [${#other_link_name[@]}] additional links..." 1
  for ((i=0; i<${#other_link_name[@]}; i++))
  do
    d_message_n "Linking:   ${BBon}[${other_link_dir[i]}] ${LBon}${other_link_name[i]}${Boff} --> ${BGon}${other_link_target[i]}${Boff} ..." 2
    cd ${SOURCES_DIR}${other_link_dir[i]}
    ln -s "${other_link_target[i]}"  "${other_link_name[i]}"
    d_right_status $? 2
  done

  cd $old_pwd
}

build_dir_tree()
{
d_message "Building directory tree in ${SOURCES_DIR} ..." 1
local treelist
if [ "${init_splash}" == "yes" ]
then
    treelist=$(grep -v "#" ${MAKE_DIR}/initramfs_dir_tree)
else
    treelist=$(grep -v "#" ${MAKE_DIR}/initramfs_dir_tree | grep -v splash)
fi
for i in ${treelist}
do
  if [ ! -e ${SOURCES_DIR}$i ]
  then
    d_message_n " Creating ${SOURCES_DIR}/$i..." 2
    mkdir ${SOURCES_DIR}$i
    d_right_status $? 2
  else
    d_message_n " Found existing ${SOURCES_DIR}/$i..." 2
    d_right_status $? 2
  fi
done
}

build_other_devices()
{
  # used to also build block device nodes, now just the console character dev
  old_dir=$(pwd)
  cd ${SOURCES_DIR}/dev/
  d_message "Changed from ${old_dir} to SOURCES_DIR: $(pwd)" 2

  # build console character device
  mknod -m 600 console c 5 1

  cd ${old_dir}
  d_message "Changed from SOURCES_DIR: ${SOURCES_DIR} tp old_dir: $(pwd)" 2
}

build_merged-usr_dir_tree_links()
{
  # get target and links to it
  local targets=('')
  local links=('')
  source ${MAKE_DIR}/initramfs_merged-usr_dir_links
  old_dir=$(pwd)
  cd ${SOURCES_DIR}
  d_message "Changed from ${old_dir} to SOURCES_DIR: $(pwd)" 2
  for ((i=0; i<${#links[@]}; i++))
  do
    # if this link doesn't exist, create it
    if [ ! -L ${links[$i]} ]
    then
      d_message_n " Creating link ${LBon}${links[$i]}${Boff} --> ${BGon}${targets[$i]}${Boff} ..." 2
      ln -s ${targets[$i]} ${links[$i]}; d_right_status $? 2
    else
      found_target="echo $(stat ${links[$i]} | head -n1 | cut -d'>' -f2)"
      d_message_n " Found existing link ${SOURCES_DIR}${links[$i]} --> ${found_target} ..." 2
      d_right_status $? 2
    fi
  done
  cd ${old_dir}
  d_message "Changed from SOURCES_DIR: ${SOURCES_DIR} tp old_dir: $(pwd)" 2
}

identify_initial_depencies_with_lddtree()
{
  # use lddtree to identify dependent libraries needed by the executables, filtering for case (3a) [see below]
  for x in $( list_executables )
  do
    lddtree ${x}
  done | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' | sort -u | cut -d' ' -f3
#  done | grep -v 'interpreter' | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' | sort -u | cut -d' ' -f3
}

identify_all_dependencies()
{
  dependencies=()
  while read library
  do
    d_message "  identified dependent library: ${library}   case: $(file ${library} | cut -d' ' -f2)  " 4
    d_message "     file: $(file ${library})  " 4
    dependencies+=("$(echo ${library})")
  done <<< $( identify_initial_depencies_with_lddtree )
}

copy_dependent_libraries()
{
  # Beginning with version 5.3.1, I'm using lddtree (from app-misc/pax-utils) instead of ldd.
  # Beginning with version 8.0.2, I've updated the algorithm to accomodate merged-usr-like layouts
  # General algorithm:  process the new list of ecutables in init_executables to identify libraries they depend on --
  #   Step 1) use the lddtree command (from app-misc/pax-utils) to identify dependencies for each executable
  #   Step 2) use the file command (from sys-apps/file) to determine how to handle each
  #   There appear to be three cases identified by the second field in the output of the file command
  #     where dir_name is the location of target_name or link_name (the executable/link) on the host system
  #     case 1 (shell script) format: dir_name/target_name
  #         Action 3:  if not already there, copy dir_name/target_name to /usr/bin
  #     case 2 (symlink) format: dir_name/link_name: symbolic link to dir_name/target_name
  #         Action 2: if not already there, copy target to dest dir (/lib or /usr/bin) amd/or make linkt to it
  #     case 3 (ELF) format: dir_name/target_name
  #       case 3a ELF is a pie executable normally identified by "interpreter" (a library; normally ld-linux-x86-64.so.2)
  #         Action 3a: if not already there, copy dir_name/target_name to /usr/bin and/or interpreter to /lib
  #       case 3b ELF is a shared object library
  #         Action 3b: if not already there, copy dir_name/target_name to /lib
  #       case 3c (subset of 1b) ELF is a shared object library that is also identified by
  #         Action 3c: if not already there, copy dir_name/target_name to /lib and/or interpreter to /lib

  d_message "Identifying dependent libraries ..." 1

  identify_all_dependencies

  d_message "Copying dependent libraries ..." 1
  for ((x=0; x<${#dependencies[@]}; x++))
  do
    # run the "file" command on each /target/path/target_name in ${dependencies[@]}
    #   the second field of this output shows if it is case (1) symlink or (2) ELF
    #   also filter vor case (3b) [see above]
    line=$(file ${dependencies[$x]})
    thiscase=$( echo $line | cut -d' ' -f2)
    d_message "  $x: ${dependencies[$x]}" 4
    d_message "    case: ${thiscase}" 4
    d_message "    examining line: ( ${line} )" 4
    case $thiscase in
      "Bourne-Again" )
        thistarget=$( echo $line | cut -d' ' -f1)
        target_name=$(basename $thistarget | sed 's/:$//')   # drop the trailing colon
        dir_name=$(dirname $thistarget)
        d_message "  Case 3 (Bourne-Again). dir_name=[$dir_name], target_name=[$target_name]" 3
        d_message "  Copy ${SOURCES_DIR}${dir_name}/$target_name..." 2
        # all executables now go in /usr/bin (merged-usr-like layout)
        d_message "  about to execute: [[ ! -e ${SOURCES_DIR}${dir_name}/$target_name ]] && copy_one_part \"${dir_name}/${target_name}\" \"${SOURCES_DIR}${dir_name}/\"" 3
        [[ ! -e ${SOURCES_DIR}${dir_name}/${target_name} ]] && \
          copy_one_part "${dir_name}/${target_name}" "${SOURCES_DIR}${dir_name}/"
      ;;
      "symbolic" )
        # copy the target executable (last item in the line) and create the symlink (first item in the line) to it
        target_name=$( echo $line | awk '{print $(NF)}' )   # $(NF) is the number of fields in awk input
        thistarget=$( echo $line | cut -d' ' -f1)
        link_name=$(basename $thistarget | sed 's/:$//')   # drop the trailing colon
        dir_name=$(dirname $thistarget)
        # ignore the special case of host system links in /lib to ../lib64 ../usr/lib or ../usr/lib64
        #   since all libs are linked to /lib in the current merged layout of this initramfs
        #   e.g.  /lib/ld-linux-aarch64.so.1: symbolic link to ../lib64/ld-linux-aarch64.so.1
        d_message "  Case 2 (symlink) dir_name=[$dir_name], link_name=[$link_name], target_name=[$target_name]" 3
        # first copy the target
        if [[ "$dir_name" == *"lib"* ]] ; then
          dest_dir="/lib"
        elif [[ "$dir_name" == *"bin"* ]]; then
          dest_dir="/usr/bin"
        fi
        d_message "  Copy/Link ${SOURCES_DIR}${dir_name}/$target_name ..." 2
        # copy the target of the link if it doesn't already exist
        d_message "  about to execute: [[ ! -e ${SOURCES_DIR}${dir_name}/$target_name ]] && copy_one_part \"${dir_name}/${target_name}\" \"${SOURCES_DIR}${dir_name}/\"" 3
        [[ ! -e ${SOURCES_DIR}${dest_dir}/${target_name} ]] && \
          copy_one_part "${dir_name}/${target_name}" "${SOURCES_DIR}${dest_dir}/"
        # next, create the link - be careful to not overwrite an executable with a link to itself
        old_pwd=$(pwd)
        cd ${SOURCES_DIR}${dest_dir}
        d_message "just changed from directory [ $old_pwd ] to directory: [ $(pwd) ]" 3
        d_message_n "Linking:   ${LBon}${link_name}${Boff} --> ${BGon}${dest_dir}/${target_name}${Boff} ..." 2
        if [[ ! -e ${SOURCES_DIR}${dest_dir}/${link_name} ]]
        then
          ln -s $target_name $link_name
          d_right_status $? 2
        else
          d_message_n " {link already exists} " 2
          d_right_status $? 2
        fi    ## [ ! -L ${SOURCES_DIR}${dir_name}/${link_name} ]
        cd $old_pwd
        d_message "just changed back to directory: [ $(pwd) ]" 3
      ;;
      "ELF" )
        # simplify for cases 1a, 1b, 1c - if they are not already there - if source dir_name is a "bin" copy target to /usr/bin
        #   if source dir is a "lib" copy target to /lib; if there is an "interpreter" copy it to /lib or /usr/bin
        thistarget=$( echo $line | cut -d' ' -f1)
        target_name=$(basename $thistarget | sed 's/:$//')   # drop the trailing colon
        dir_name=$(dirname $thistarget)
        if [[ "$dir_name" == *"lib"* ]] ; then
          dest_dir="/lib"
        elif [[ "$dir_name" == *"bin"* ]]; then
          dest_dir="/usr/bin"
        fi
        d_message "  Case 3 (ELF). dir_name=[$dir_name], target_name=[$target_name] dest_dir=[$dest_dir]" 3
        d_message "  Copy/Link ${SOURCES_DIR}${dest_dir}/$target_name ..." 2
        # copy the executable target if it diesn't already exist
        d_message "  about to execute: [[ ! -e ${SOURCES_DIR}${dest_dir_name}/$target_name ]] && copy_one_part \"${dir_name}/${target_name}\" \"${SOURCES_DIR}${dest_dir}/\"" 3
        [[ ! -e ${SOURCES_DIR}${dest_dir}/${target_name} ]] && \
          copy_one_part "${dir_name}/${target_name}" "${SOURCES_DIR}${dest_dir}/"
        # if this executable also has an interpreter, ensure it is also loaded
        if [[ "$line" == *"interpreter"* ]]; then
          interpreter=$(basename $(echo ${line#*"interpreter"} | cut -d',' -f1))
          sourcefile=$(find / -name ${interpreter} 2>/dev/null | grep -v ${SOURCES_DIR})
          dir_name=$(dirname ${sourcefile})
          if [[ "$dir_name" == *"lib"* ]] ; then
            dest_dir="/lib"
          elif [[ "$dir_name" == *"bin"* ]]; then
            dest_dir="/usr/bin"
          fi
          d_message "  Copy ${SOURCES_DIR}${dest_dir}/${interpreter} ..."
          [[ ! -e ${SOURCES_DIR}${dest_dir}/${interpreter} ]] && \  
            copy_one_part "${sourcefile}" "${SOURCES_DIR}${dest_dir}/"
        fi
      ;;

      * )
        E_message "error in copying/linking dependencies"
        exit 1
      ;;
    esac
    d_message "--------------------------------------------" 3
  done

  # address rare issue with error "libgcc_s.so.1 must be installed for pthread_cancel to work"
  # occurs when cryptsetup tries to open LUKS volume - see references (similar but different) --
  #   https://bugs.gentoo.org/760249 (resolved by fix to dracut)
  #   https://forums.gentoo.org/viewtopic-t-1096804-start-0.html (zfs problem. fix: copy file to initramfs)
  #   https://forums.gentoo.org/viewtopic-t-1049468-start-0.html (also zfs problem. same fix)
  # at least for now, I'm using the same fix here --

  # ( if needed, find and copy the missing file to /lib64/libgcc_s.so.1
  #   - then copy it to ${SOURCES_DIR}. Note: in this initramfs, /lib64 is a symlink to /lib )
  if [[ ! -e /lib64/libgcc_s.so.1 ]]
  then
    selector=$(gcc -v 2>&1 | grep Target | cut -d' ' -f2)
    searched_file="$( find /usr/ -iname libgcc_s.so.1 2>/dev/null | grep -v 32 | grep ${selector})"
    cp -v "${searched_file}" /lib64/libgcc_s.so.1
  fi
  missing_file=/lib64/libgcc_s.so.1
  target_name=$(basename ${missing_file})
  dir_name=$(dirname ${missing_file})

  d_message "  about to copy missing file [ ${missing_file} ] to ${SOURCES_DIR}${dir_name}/$target_name " 2
  [[ ! -e ${SOURCES_DIR}${dir_name}/${target_name} ]] && \
     copy_one_part "${dir_name}/${target_name}" "${SOURCES_DIR}${dir_name}/"
}

#---[ Main Script ]-------------------------------------------------------
# Create the required directory structure -- maintain the file
#   ${MAKE_DIR}/initramfs_dir_tree to tailor this
separator "Make Sources"  "mkinitramfs-$BUILD"
checkroot
display_config

# determine if splash is requested in init.conf
eval $(grep "splash" ${config_file} | grep -v "#")
[ "${init_splash}" == "yes" ] && d_message "splash requested" 1 || d_message "splash not requested" 1

separator "Build directory tree, device nodes, and links"  "mkinitramfs-$BUILD"
build_dir_tree
build_other_devices
build_merged-usr_dir_tree_links

separator "Load list of executables"
load_executables

separator "Check for Parts"  "mkinitramfs-$BUILD"
check_for_parts

separator "Copy Parts"  "mkinitramfs-$BUILD"
copy_parts

separator "Create Symlinks"  "mkinitramfs-$BUILD"
create_links

separator "Copy Dependent Libraries"  "mkinitramfs-$BUILD"
copy_dependent_libraries

separator "Create the BUILD reference file"  "mkinitramfs-$BUILD"
echo "BUILD=\"${BUILD}\"" > ${SOURCES_DIR}/BUILD

d_message "cleaning up..." 1
# nothing to do here anymore...
d_message "All Done" 1
