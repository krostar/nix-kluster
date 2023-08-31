{
  lib,
  pkgs,
  ...
}: let
  valueJSON = builtins.toJSON [
    (lib.kluster.recursiveMerge [{} {}])
    (lib.kluster.recursiveMerge [{a = 1;} {a = 2;} {a = 3;}])
    (lib.kluster.recursiveMerge [
      {
        a = {
          a = 1;
          b = true;
          c = [2 3];
        };
      }
      {d = false;}
      {a.c = [4];}
    ])
    (lib.kluster.recursiveMerge [
      {a = {a = true;};}
      {a.a = [4];}
    ])
  ];

  expectedValueJSON = builtins.toJSON [
    {}
    {a = 3;}
    {
      a = {
        a = 1;
        b = true;
        c = [2 3 4];
      };
      d = false;
    }
    {
      a = {a = [4];};
    }
  ];
in
  pkgs.runCommand "test.lib/recursiveMerge" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${valueJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedValueJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${valueJSON}' --argjson y '${expectedValueJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
