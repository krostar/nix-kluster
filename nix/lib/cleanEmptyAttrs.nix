{lib}:
/*
filter out empty attr from set
*/
attr:
lib.foldr (a: b: lib.recursiveUpdate a b) {} (
  builtins.map (
    item: lib.setAttrByPath item.keys item.value
  ) (
    lib.collect (
      value: (builtins.isAttrs value) && (lib.attrByPath ["_marker"] false value) == true
    ) (
      lib.mapAttrsRecursive (keys: value: {
        inherit keys value;
        _marker =
          if builtins.isAttrs value
          then builtins.length (builtins.attrNames value) != 0
          else true;
      })
      attr
    )
  )
)
