{
  lib,
  pkgs,
  ...
}: let
  attrs = {
    a1 = {
      a2 = {
        a3 = 1;
        a4 = 2;
      };
    };
    b1 = {};
    c1 = {
      c2 = {};
      c3 = {
        c4 = {
          c5 = {
            c6 = {
              c7 = {};
            };
            c8 = {};
          };
          c9 = {};
        };
        c10 = 3;
      };
    };
  };

  filteredAttrs = lib.kluster.cleanEmptyAttrs attrs;
  filteredAttrsJSON = builtins.toJSON filteredAttrs;

  expectedFilteredAttrs = {
    a1.a2.a3 = 1;
    a1.a2.a4 = 2;
    c1.c3.c10 = 3;
  };
  expectedFilteredAttrsJSON = builtins.toJSON expectedFilteredAttrs;
in
  pkgs.runCommand "test.lib/cleanEmptyAttrs" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${filteredAttrsJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedFilteredAttrsJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${filteredAttrsJSON}' --argjson y '${expectedFilteredAttrsJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
