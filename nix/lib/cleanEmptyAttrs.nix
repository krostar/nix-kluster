{lib}:
/*
filter out empty attr from set
*/
attr:
lib.foldr lib.recursiveUpdate {} (
  builtins.map (
    item: lib.setAttrByPath item.keys item.value
  ) (
    lib.collect (
      value: (builtins.isAttrs value) && (lib.attrByPath ["_marker"] false value)
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
