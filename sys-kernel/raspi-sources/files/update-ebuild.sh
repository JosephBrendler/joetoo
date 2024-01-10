#!/bin/bash
# This folder contains a full clone, created with "git clone https://github.com/raspberrypi/linux.git"
# Technique: cd linux; git pull; git status; update-ebuild.sh <new-branch>

#-----[ function (run as user) ]-------------------------------------------
update_ebuild() {
  newbranch="$1"

  PN="raspi-sources"
  local_repodir=/home/joe/${PN}/
  ebuild_dir="/home/joe/joetoo/sys-kernel/${PN}"

  old_dir="$(pwd)"
  cd ${local_repodir}
  if [ -d ./linux ]
  then
    cd linux
    git pull
  else
    git clone https://github.com/raspberrypi/linux.git 
    cd linux
  fi
  git branch --list --remotes
#  git checkout rpi-6.2.y
  git checkout ${newbranch} || exit 1
# note branch and commit ID of head commit
# copy current ebuild at /home/joe/joetoo/sys-kernel/raspi-sources
# cp raspi-sources-${oldversion}.ebuild raspi-sources-${newversion}.ebuild
# nano raspi-sources-${newversion}.ebuild
# change EGIT_BRANCH and EGIT_COMMIT

  newbranch=$(git status | head -n1 | awk '{print $3}')
  newversion=$(make kernelversion)
  newcommit=$(git log | head -n1 | cut -d' ' -f2)

  eval $(grep EGIT_BRANCH ${ebuild_dir}/${PN}-${newversion}.ebuild | grep -v einfo)
  oldbranch=${EGIT_BRANCH}
  eval $(grep EGIT_COMMIT ${ebuild_dir}/${PN}-${newversion}.ebuild | grep -v einfo)
  oldcommit=${EGIT_COMMIT}

  for x in $(find ${ebuild_dir} -type f -iname "${PN}-*" | sort)
  do
    ebuild_list+=("${x}")
  done

  oldversion=$(echo $(basename ${ebuild_list[$((${#ebuild_list[@]}-1))]}) | \
    sed "s|${PN}-||" | sed "s|.ebuild||")

  echo "oldversion..: ${oldversion}"
  echo "newversion..: ${newversion}"
  echo "oldbranch...: ${oldbranch}"
  echo "newbranch...: ${newbranch}"
  echo "oldcommit...: ${oldcommit}"
  echo "newcommit...: ${newcommit}"

  cp ${ebuild_dir}/${PN}-${oldversion}.ebuild ${ebuild_dir}/${PN}-${newversion}.ebuild

  sed -i "s|${oldbranch}|${newbranch}|g" ${ebuild_dir}/${PN}-${newversion}.ebuild
  sed -i "s|${oldcommit}|${newcommit}|g" ${ebuild_dir}/${PN}-${newversion}.ebuild

  cd ${ebuild_dir}
  rm Manifest
  pkgdev manifest -f
  git status
  git add Manifest
  git add ../../metadata/md5-cache/sys-kernel/raspi-sources-${newversion}
  git add raspi-sources-${newversion}.ebuild
  git commit -m "adding ebuild for ${PN}-${newversion}"
  git push origin master
  cd ${old_dir}
}

#-----[ main script ]-------------------------------------
update_ebuild "$1"
