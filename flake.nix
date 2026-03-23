{
  outputs =
    {
      self,
    }:
    {
      lib =
        { nixpkgs }:
        with nixpkgs.lib;
        rec {
          pipe = {
            inherit mkTf;
            terraform = attrs: pipe: pipe ++ [ (terraform attrs) ];
            provider = attrs: pipe: pipe ++ [ (provider attrs) ];
            variable =
              name: attrs: pipe:
              pipe ++ [ (variable name attrs) ];
            resource =
              type: name: attrs: pipe:
              pipe ++ [ (resource type name attrs) ];
            output =
              name: attrs: pipe:
              pipe ++ [ (output name attrs) ];
          };

          terraform = attrs: {
            terraform = attrs;
          };

          provider = attrs: {
            provider = attrs;
          };

          variable = name: attrs: {
            variable.${name} = attrs;
          };

          resource = type: name: attrs: {
            resources.${type}.${name} = attrs;
          };

          output = name: attrs: {
            output.${name} = attrs;
          };

          mkTf = list: nixpkgs.lib.toJSON (foldl' recursiveUpdate { } list);
        };
    };
}
