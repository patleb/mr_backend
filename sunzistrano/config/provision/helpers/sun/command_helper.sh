sun.install() {
  if sun.installed "$@"; then
    echo "$@ already installed"
  else
    sun.mute "$os_package_get -y install $@"
  fi
}

sun.installed() {
  $os_package_installed $@ >/dev/null 2>&1
  return $?
}

sun.remove() {
  sun.mute "$os_package_get -y remove $@"
}

sun.update() {
  if [[ ! -z "$@" ]]; then
    sun.mute "$os_package_update"
  else
    sun.mute "$os_package_update"
  fi
}

sun.upgrade() {
  $os_package_upgrade
}

sun.lock() {
  $os_package_lock $@
}

sun.unlock() {
  $os_package_unlock $@
}

sun.mute() {
  echo "Running \"$@\""
  `$@ >/dev/null 2>&1`
  return $?
}

sun.provision_path() {
  echo "$HOME/$__PROVISION_DIR__"
}
