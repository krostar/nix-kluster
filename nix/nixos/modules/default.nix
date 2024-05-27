let
  kluster = import ./kluster;
in {
  default = kluster;
  inherit kluster;
}
