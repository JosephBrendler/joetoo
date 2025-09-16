#!/bin/bash
#
# run these commands from the directory containing these img files
# based on Armbian platform_install.sh script
# provides a menu dialog to choose one of several spi_loader options
# "zero.img.gz" downloaded from https://docs.radxa.com/en/rock5/lowlevel-development/bootloader_spi_flash 6/2/25
# (decompressed with gzip and verified with hexedit that it is all zero data)
# "rkspi_loader.img" downloaded from https://github.com/huazi-yg/rock5b 6/2/25
# "release" and "debug" versions downloaded from https://dl.radxa.com/rock5/sw/images/loader/ 6/2/25
#     "release" version has u-boot serial console disabled
#     "debug" version has u-boot serial console enabled
#     "rkspi_loader.img" -- radxa says "Use it when you need to install the armbian Image to M.2 NVME SSD"
#     (copied here as rkspi_loader_radxa.img)
#     Note: Armbian build also produced a rkspi_loader.img file of size 16777216
#     (precisely same size as /dev/mtdblock0 [16MiB] as are the other img files)
#     (copied here as rkspi_loader_armbian.img)
#ZERO=zero.img
#IMAGE=debug/rock-5b-spi-image-gd1cf491-20240523-debug.img   ### pick your choice
#TARGET=/dev/mtdblock

#dd if=${ZERO} of=${TARGET} conv=notrunc status=progress; sync ;
#md5sum ${ZERO} ${TARGET} ;
#echo; echo;

#dd if=${IMAGE} of=${TARGET} conv=notrunc status=progress; sync ;
#md5sum ${IMAGE} ${TARGET

# alternatively, run this script from the directory containing these img files
# (based on write_uboot_platform_mtd() function in Armbian platform_install.sh script
source /usr/local/sbin/script_header_joetoo

varlist="BUILD bool.INTERACTIVE bool.RESUME starting_step stopping_step"
varlist+=" BREAK PN DIR TARGET ZERO IMAGE"
varlist+=" BREAK bool.VERBOSE verbosity"

command_sequence=(
'zero-flash'
'write_uboot_platform_mtd'
)

msg1_sequence=(
'flash zero image to platform mtd device'
'write uboot rkspi_loader image to platform mtd device'
)

msg2_sequence=(
'flashing zero image to platform mtd device'
'writing uboot rkspi_loader image to platform mtd device'
)

starting_step=0
stopping_step=${#command_sequence[@]}

INTERACTIVE=$TRUE

#-----[ functions ]---------------------------------------------------------------------------------

display_configuration()  {
    # will pick up PN, BUILD, varlist from the environment of whatever script sources cb-common-functions
    separator "configuration" "${PN}-${BUILD}"
    longest=$(get_longest ${varlist})
    display_vars ${longest} ${varlist}
    return 0
}

initialize_variables() {
    [ $verbosity -lt 2 ] && message_n "initializing ..." || message "initializing ..."
    initialize_vars ${varlist}

    # set default values
    d_message_n "setting default starting_step = 0" 2
    export starting_step=0 && d_right_status $? 2 ; d_right_status $? 2
    d_message_n "setting default stopping_step = $(( ${#command_sequence[@]} - 1 ))" 2
    export stopping_step=$(( ${#command_sequence[@]} - 1 )) ; d_right_status $? 2
    d_message_n "setting default rkspi_loader_reflash_statusfile = /root/bin/rkspi_loader_reflash_status" 2
    export rkspi_loader_reflash_statusfile="/root/bin/rkspi_loader_reflash_status" ; d_right_status $? 2
    d_message_n "setting PN = $(basename $0)" 2
    PN=$(basename $0) ; d_right_status $? 2
    d_message_n "setting default INTERACTIVE true" 2
    export INTERACTIVE=$TRUE ; d_right_status $? 2
    d_message_n "setting default VERBOSE true" 2
    export VERBOSE=$TRUE ; d_right_status $? 2
    d_message_n "setting default verbosity = 3" 2
    export verbosity=3 ; d_right_status $? 2

    d_message_n "setting default DIR = /boot/u-boot_reflash_resources/radxa-rock-5b-u-boot-rkspi_loader-reflash-resources" 2
    export DIR=/boot/u-boot_reflash_resources/radxa-rock-5b-u-boot-rkspi_loader-reflash-resources ; d_right_status $? 2
    d_message_n "setting default TARGET = /dev/mtdblock0" 2
    export TARGET=/dev/mtdblock0 ; d_right_status $? 2
    d_message_n "setting default ZERO = zero.img" 2
    export ZERO=zero.img ; d_right_status $? 2

    IMAGE="<TBD>"
    BUILD=0.0.0

    message "initialization complete"
}

validate_blockdev() {
    TGT=$1
    if [ ! -b ${TGT} ] ; then
        E_message "blockdev ${TGT} ${BRon}not found${Boff}"
        exit 1
    else
        message "blockdev ${TGT} ${BGon}validated${Boff}"
    fi
}

validate_imagefile() {
    TGT=$1
    if [ ! -f ${TGT} ] ; then
        E_message "image file ${TGT} ${BRon}not found${Boff}"
        exit 1
    else
        message "image file ${TGT} ${BGon}validated${Boff}"
    fi
}

check_flash_result(){
    SOURCE=$1
    SOURCE_result=$(md5sum ${SOURCE} | awk '{print $1}')
    target_result=$(md5sum ${TARGET} | awk '{print $1}')
    if [[ "${SOURCE_result}" == "${target_result}" ]] ; then
        message "${BGon}(success)${Boff} SOURCE_result [${SOURCE_result}] ${BGon}equals${Boff} target_result [${target_result}]"
    else
        E_message "{BRon}(failure)${Boff} SOURCE_result [${SOURCE_result}] ${BRon}not equal to${Boff} target_result [${target_result}]"
        E_message "flash program for ${SOURCE}"
        exit 1
    fi
}

zero-flash() {
    message_n "zeroing mtd device ${TARGET} (est. 6 min.) ..."
    dd if=${ZERO} of=${TARGET} conv=notrunc status=none > /dev/null 2>&1 ; right_status $?
    sync
    check_flash_result "${ZERO}"
    return $?
}

write_uboot_platform_mtd() {
    message_n "looking for rkspi_loader images in ${DIR} ..."
    FILES=$(find "${DIR}" -maxdepth 1 -type f -name "rkspi_loader*.img"); right_status $?
    d_message "found FILES: \n${FILES}" 3
    if [ -z "$FILES" ]; then
        echo "No SPI image found.";
        exit 1;
    fi;
    d_message_n "getting filenames for menu ..." 3
    MENU_ITEMS=();
    i=1;
    while IFS= read -r file; do
        filename=$(basename "$file");
        MENU_ITEMS+=("$i" "$filename" "");
        ((i++));
    done <<< "$FILES"; right_status $?
    # i=2 means incremented only once - i.e. only one menu entry
    d_message "MENU_ITEMS list contains $(($i - 1)) entry(ies)" 3
    if [[ $i -eq 2 ]]; then
        IMAGE="${DIR}/${MENU_ITEMS[1]}"
        validate_imagefile "${IMAGE}"
        message_n "now writing ${IMAGE} to uboot platform mtd (est. 6 min.) ..."
        dd if=${IMAGE} of=${TARGET} conv=notrunc status=none > /dev/null 2>&1 ; right_status $?
        sync
        return 0;
    fi;
    d_message "creating dialog menu ..." 3
    backtitle="u-boot rkspi_loader.img install script for rock-5b";
    CHOICE=$(dialog --no-collapse --title "rkspi_loader-install" --backtitle "${backtitle}" --radiolist "Choose SPI image:" 0 56 $(($i-1)) "${MENU_ITEMS[@]}" 3>&1 1>&2 2>&3)
    result=$? ; right_status $result
    d_message "CHOICE: $CHOICE" 3
    if [ $result -eq 0 ]; then
        IMAGE="${DIR}/${MENU_ITEMS[($CHOICE*3)-2]}"
        validate_imagefile "${IMAGE}"
        message_n "now writing ${IMAGE} to uboot platform mtd (est. 6 min.) ..."
        dd if=${IMAGE} of=${TARGET} conv=notrunc status=none > /dev/null 2>&1 ; right_status $?
        sync
    else
        echo "No SPI image chosen.";
        exit 1;
    fi
    check_flash_result "${IMAGE}"
    return $?
}


run_sequence() {
    # run the sequence of commands stored in the command_sequence array
    # for each step, store updated status in a status file provided as arg $1
    [ $# -ne 1 ] && E_message "run_sequence requires exactly one argument (status_file) " && exit 1
    status_file=$1
    echo
    separator "Running command sequence" "${PN}-${BUILD}"
    echo
    d_message "starting_step: [ ${starting_step} ]" 3
    d_message "stopping_step: [ ${stopping_step} ]" 3
    for ((step_number=${starting_step}; step_number<=${stopping_step}; step_number++))
    do
        separator "(${step_number}: ${command_sequence[${step_number}]})" "${PN}-${BUILD}"
        d_message "Writing step_number [ $step_number ] to status_file ( $status_file )" 2
        echo $step_number > ${status_file}
        if [[ ${INTERACTIVE} ]] ; then
            msg="INTERACTIVE: $(status_color $INTERACTIVE)$(TrueFalse $INTERACTIVE)${Boff}"
            msg+=" ; will prompt to ${step_number}: (${msg1_sequence[${step_number}]})"
            d_message "${msg}" 2
            response=""
            # confirm user is ready/wants to run the next command
            new_prompt "${BMon}Are you ready to ${BGon}${msg1_sequence[${step_number}]}${BMon}?${Boff}"
        else  # automatically execute other steps for non-interactive
            msg="INTERACTIVE: $(status_color $INTERACTIVE)$(TrueFalse $INTERACTIVE)${Boff}"
            msg+=" ; will automatically ${step_number}: (${msg1_sequence[${step_number}]})"
            d_message "${msg}" 2
            message "${BMon}Beginning ${BGon}${command_sequence[${step_number}]}${BMon} as instructed ...${Boff}"
            response="y"
       fi  ## interactive
       case $response in
           [Yy] )  # execute this command and continue
               message "${LBon}About to run ${BYon}${command_sequence[${step_number}]}${LBon} ...${Boff}" ; \
               eval ${command_sequence[${step_number}]} ; result=$? ;
               if [ ${result} -eq 0 ] ; then
                   message "${BYon}Note:${Boff} ${command_sequence[${step_number}]} ${BGon}completed successfully${Boff}"
               else
                   E_message "${BYon}Note:${Boff} ${command_sequence[${step_number}]} ${BRon}failed${Boff}"
               fi
               ;;
           [Ss] ) ;; # skip this command and continue
           *    )  # abort due to negative response
               message "${BRon}As instructed, not running ${BGon}${command_sequence[${step_number}]}${BRon}. Quitting...${Boff}" ; \
               exit ;;
        esac

    done
    echo
}

validate_status_file() {
    [ $# -ne 1 ] && E_message "Error: must specify status_file" && return 1
    status_file=$1
    d_message "status_file: [ ${status_file} ]" 3
    status_dir=$(dirname ${status_file})
    d_message "status_dir: [ ${status_dir} ]" 3
    message_n "validating status_dir [${status_dir}] ..."
    if [ ! -d ${status_dir} ] ; then
        echo -en " (creating) ..."
        mkdir -p ${status_dir} && right_status $? || ( right_status $? && return 1 )
    else
        echo -en " (valid)" ; right_status $TRUE
    fi
    message_n "validating status_file [${status_file}] ..."
    if [ ! -f ${status_file} ] ; then
        echo -en " (creating) ..."
        touch ${status_file} && right_status $? || ( right_status $? && return 1 )
    else
        echo -en " (valid)" ; right_status $TRUE
    fi
    # final validation
    message_n "re-verifying status_file [${status_file}] ..."
    [ -f ${status_file} ] && result=$TRUE || result=1
    right_status $result
    return $result
}

new_prompt()        # set external variable $response based on reponse to prompt $1
{ ps=$1; echo; echo; CUU; SCP; message_n "$ps [Yes/no/skip|Yns]: " && read response; # '=~' not in busybox
while ! expr "${response:0:1}" : [yYnNsS] >/dev/null;  # response not a regex match
do RCP; echo -en "$(repeat ' ' $(termwidth))";  ## blank the line
RCP; message_n "$ps [Yes/no/skip|Yns]: " && read response; done; }


process_cmdline() {
  # process command line arguments (for now only -x/--exclude option can have argument(s))
  arglist="$@"

  last=""
  d_message "processing command line with [ ${arglist} ]" 2
  # shift each argument into position $1 and examine it
  #   process the argument or processit with its own arguments
  while [ ! -z "$1" ]
  do
    d_message "arg1 = [ $1 ]" 3
    # if arg begins with a single dash, process it alone
    if [ "${1:0:1}" == "-" ] && [ "${1:1:1}" != "-" ] ; then
      d_message "processing [ $1 ] alone as single-dash argument" 3
      process_argument $1 $2   # incl $2 in case $1 is -t or -b
      [[ "${1}" =~ ^(-t|-b)$ ]] && shift  # extra shift to clear target or board
      shift
    # if arg begins with a double dash, process it alone
    elif [ "${1:0:2}" == "--" ] ; then
      d_message "processing [ $1 ] alone as double-dash argument" 3
      process_argument $1 $2   # incl $2 in case $1 is --target
      [[ "$1" == "--target" ]] && shift  # extra shift to clear target
      shift
    else
      d_message "does not start with - or --" 3
      usage; exit
    fi
  done
  d_message "done with process_command_line" 2
  return 0
}

process_argument() {
  d_message "about to process [ $* ]" 2
  d_message "1: [ $1 ], 2: [ $2 ]" 2
  # process command line argument (must be one of the following)
  [ ! -z "$1" ] && case "$1" in
    "-"[sS] | "--status"         )
      # display status
      d_message "${BYon}reading status file: [ ${BWon}${mkenvstatusfile}${BYon}  ]${Boff}" 2
      read starting_step < ${mkenvstatusfile};
      msg="${BWon}Status: Step $(($starting_step - 1)) complete;"
      msg+=" next step would be [ ${BMon}$starting_step${BWon} ]"
      msg+=" --[ ${BGon}${command_sequence[${starting_step}]}${BWon} ]${Boff}"
      message "${msg}"
      exit;
      ;;
    "-"[rR] | "--resume"         )
      # resume at stored step unless that is overridden by a new start # (below)
      d_message "${BYon}reading status file: [ ${BWon}${mkenvstatusfile}${BYon}  ]${Boff}" 2
      export RESUME=${TRUE}
      read starting_step < ${mkenvstatusfile};
      msg="${BWon}Resuming at step [ ${BMon}$starting_step${BWon} ]"
      msg+=" --[ ${BGon}${msg1_sequence[${starting_step}]}${BWon} ]--${Boff}"
      d_message "${msg}" 2
      ;;
    -*[0-9]*  )
        # currently there are double-digit steps; if the next char is also numeric, append it
        myarg=${1:1} # drop the leading "-"
        export RESUME=${TRUE}
        if $(isnumber ${myarg}) && [ ${myarg} -ge 0 ] && \
          [ ${myarg} -lt ${#command_sequence[@]} ] ; then
            export starting_step=${myarg};
            msg="${BYon}Saving next step ${BWon}${starting_step}${BYon}"
            msg+=" to status file [${Boff}${finishupstatusfile}${BYon}]${Boff}"
            d_message "${msg}" 2
            echo ${starting_step} > ${finishupstatusfile};
            msg="${BWon}Resuming at step [ ${BMon}${starting_step}${BWon} ]"
            msg+=" --[ ${BGon}${msg1_sequence[${starting_step}]}${BWon} ]--${Boff}"
            d_message "${msg}" 2
        else
            # it may be a combination of numbers and letters - hand off to process_compound_arg()
            process_compound_arg $1
        fi
        ;;
    "-"[iI] | "--interactive"    )
      # interactive
      export INTERACTIVE=${TRUE};
      d_message "${BYon}setting INTERACTIVE: $(status_color ${INTERACTIVE})$(TrueFalse ${INTERACTIVE})${Boff}" 2
      ;;
    "-"[nN] | "--noninteractive" )
      # non-interactive
      export INTERACTIVE=${FALSE}
      d_message "${BYon}setting INTERACTIVE: $(status_color ${INTERACTIVE})$(TrueFalse ${INTERACTIVE})${Boff}" 2
      ;;
    "-"[qQ] | "--quiet"          )
      # decrease verbosity
      [[ ${verbosity} -gt 0 ]] && let verbosity--
      [[ ${verbosity} -eq 0 ]] && export VERBOSE=${FALSE}
      d_message "${BYon}decreased verbosity: ${verbosity}${Boff}" 2
      ;;
    "-"[vV] | "--verbose"          )
      # increase verbosity
      [[ ${verbosity} -lt 6 ]] && let verbosity++
      export VERBOSE=${TRUE}
      d_message "${BYon}increased verbosity: ${verbosity}${Boff}" 2
      ;;       # note: "numeric" args like -4 should fall through to this default
    "-"[zZ] | "--zero"    )
      # zero
      export starting_step=$(linear_search 'zero-flash' "${command_sequence[@]}")
      export stopping_step=${starting_step}
      d_message "${BYon}set start/stop steps for zero flash" 2
      ;;
    "-"[fF] | "--flash"    )
      # flash
      export starting_step=$(linear_search 'write_uboot_platform_mtd' "${command_sequence[@]}")
      export stopping_step=${starting_step}
      d_message "${BYon}set start/stop steps for rkspi_loader image flash" 2
      ;;
    *                            )
    process_compound_arg $1
      ;;
  esac
  d_message "done with process_argument" 3
  return 0
}

process_compound_arg()  {
    d_message "about to process compound [ $* ]" 2
    # must begin with a single dash
    [ ! "${1:0:1}" == "-" ] && E_message "${E_BAD_ARGS}" && usage && exit 1
    # must not begin with two dashes (would have been picked in process_argument)
    [ "${1:0:2}" == "--" ] && E_message "${E_BAD_ARGS}" && usage && exit 1
    # strip leading dash(es)
    myargs=${1##-}
    # handle remaining characters in sequence
    while [ -n "${myargs}" ]
    do
        #handle one character at at time, from the left
        case ${myargs:0:1} in
            [sS] )
                # display status
                d_message "${BYon}reading status file: [ ${BWon}${mkenvstatusfile}${BYon}  ]${Boff}" 2
                read starting_step < ${mkenvstatusfile};
                msg="${BWon}Status: Step $(($starting_step - 1)) complete;"
                msg+=" next step would be [ ${BMon}$starting_step${BWon} ]"
                msg+=" [ ${BGon}${command_sequence[${starting_step}]} ${BWon}]${Boff}"
                d_message "${msg}" 2
                exit;
                ;;
            [rR] )
                # resume at stored step unless that is overridden by a new start # (below)
                d_message "${BYon}reading status file: [ ${BWon}${mkenvstatusfile}${BYon}  ]${Boff}" 2
                export RESUME=${TRUE}
                read starting_step < ${mkenvstatusfile};
                msg="${BWon}Resuming at step [ ${BMon}$starting_step${BWon} ]"
                msg+=" --[ ${BGon}${msg1_sequence[${starting_step}]}${BWon} ]--${Boff}"
                d_message "${msg}" 2
                ;;
            [0-9] )
                # if there are double-digit steps, then if the next char is also numeric, append it and "shift"
                export RESUME=${TRUE}
                starting_step="${myargs:0:1}";
                if [[ "${myargs:1:1}" == [0-9] ]] ; then
                    export starting_step="${myargs:0:2}";
                    myargs=${myargs:1}
                fi
                if [ $starting_step -gt ${#command_sequence[@]} ] ; then
                    E_message "invalid starting_step [${starting_step}]"
                    usage
                else
                    msg="${BYon}Saving next step ${BWon}${starting_step}${BYon}"
                    msg+=" to status file [${Boff}${mkenvstatusfile}${BYon}]${Boff}"
                    d_message "${msg}" 2
                    echo ${starting_step} > ${mkenvstatusfile};
                    msg="${BWon}Resuming at step [ ${BMon}${starting_step}${BWon} ]"
                    msg+=" --[ ${BGon}${msg1_sequence[${starting_step}]}${BWon} ]--${Boff}"
                    d_message "${msg}" 2
                fi
                ;;
            [iI] )
                # interactive
                export INTERACTIVE=${TRUE};
                d_message "${BYon}setting INTERACTIVE: $(status_color ${INTERACTIVE})$(TrueFalse ${INTERACTIVE})${Boff}" 2
                ;;
            [nN] )
                # non-interactive
                export INTERACTIVE=${FALSE}
                d_message "${BYon}setting INTERACTIVE: $(status_color ${INTERACTIVE})$(TrueFalse ${INTERACTIVE})${Boff}" 2
                ;;
            [qQ] )
                # decrease verbosity
                [[ ${verbosity} -gt 0 ]] && let verbosity--
                [[ ${verbosity} -eq 0 ]] && export VERBOSE=${FALSE}
                d_message "${BYon}decreased verbosity: ${verbosity}${Boff}" 2
                ;;
            [vV] )
                # increase verbosity
                [[ ${verbosity} -lt 6 ]] && let verbosity++
                export VERBOSE=${TRUE}
                d_message "${BYon}increased verbosity: ${verbosity}${Boff}" 2
                ;;       # note: "numeric" args like -4 should fall through to this default
            [zZ] )
                # zero
                export starting_step=$(linear_search 'zero-flash' "${command_sequence[@]}")
                export stopping_step=${starting_step}
                d_message "${BYon}set start/stop steps for zero flash" 2
                ;;
            [fF] )
                # flash
                export starting_step=$(linear_search 'write_uboot_platform_mtd' "${command_sequence[@]}")
                export stopping_step=${starting_step}
                d_message "${BYon}set start/stop steps for rkspi_loader image flash" 2
                ;;
            *   ) E_message "${E_BAD_ARGS}" && usage && exit 1
        esac
        #strip first char from myargs (i.e. "shift" one character)
        myargs=${myargs:1}
    done
    d_message "done with process_compount_arg" 3
    return 0
}

linear_search() {  # find $2 in array $1, return index
    # pass arguments like this usage:
    # linear_search 'cb-setup ${BOARD}' "${command_sequence[@]}"
    #
    needle="$1" ; shift ; haystack=("$@")
#    echo "needle: ${needle}"
#    echo "haystack length: ${#haystack[@]}"
    for ((i=0; i<${#haystack[@]}; i++ )) ; do
        [[ "${haystack[$i]}" == "${needle}" ]] && echo $i && return $i
    done
}

usage() {
  N=$(( ${#command_sequence[@]} -1 ))
  separator "${PN}-${BUILD}" "$(hostname)"
  E_message "${BRon}Usage: ${BGon}${PN} [-[options]]${Boff}"
  message "${BYon}Valid Options --${Boff}"
  message "  -i | --interactive......: run interactively; confirm execution of each step"
  message "  -n | --noninteractive...: run non-interactively; proceed automatically with each step"
  message "  -s | --status...........: return status (next step, step_number)"
  message "  -r | --resume...........: resume proccessing (with next step, from mkenvstatusfile)"
  message "  -v | --verbose..........: increase verbosity"
  message "  -q | --quiet............: decrease verbosity"
  message "  -z | --zero.............: just zero-flash the platform mtd"
  message "  -f | --flash............: just image-flash the platform mtd"
  message "  -[0-${N}].................: save N to status file and resume at step N"
  echo
  message "${BMon}Note: single-character options may be combined. For example -${Boff}"
  message "  ${BGon}${PN} --verbose -nqr1 ${Boff}"
  message "  ${BYon}would resume non-interactively at step 1 with normal verbosity${Boff}"
  echo
  message "${BMon}Other notes:${Boff}"
  message "   - options -i (interactive) is on by default"
  message "   - option  -r (resume) sets starting_step to value in statusfile [ ${rkspi_loader_reflash_statusfile} ]"
  message "   - option  -[0-${N}] sets starting_step to the specified value"
  message "   - manufacturer recommends zero-flash prior to new image-flash"
  echo
  message "${BYon}Command sequence steps:${Boff}"
  for ((s=0; s<${#command_sequence[@]}; s++))
  do
    echo -e "    ${LBon}${s}: ${command_sequence[$s]}${Boff}"
  done
  exit 1
}

#-----[ main script ]---------------------------------------------------------------------------------
checkroot
separator "${PN}-${BUILD}" $(hostname)
# check for dialog [ to do: build package with dependency ]
if [ ! -e /usr/bin/dialog ] ; then
    E_message "this program is dependent on dev-util/dialog, which does not appear to be installed"
    exit 1
fi

initialize_variables

d_echo "cmdline: $*" 5
d_echo "processing cmdline args: $@" 5

msg="processing cmdline ..."
[ $verbosity -lt 2 ] && message_n "${msg}" || message "${msg}"
process_cmdline "${@}"   # override defaults
right_status $?

validate_status_file ${rkspi_loader_reflash_statusfile} && \
validate_imagefile ${ZERO} && \
validate_blockdev ${TARGET} && \
display_configuration

# write_uboot_platform_mtd() will validate_imagefile ${IMAGE} for selected image
run_sequence ${rkspi_loader_reflash_statusfile}
