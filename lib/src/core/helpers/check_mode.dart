bool isDevMode() {
  const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
  return isDebug;
}
