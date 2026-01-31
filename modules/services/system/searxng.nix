{
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.system.searxng;
in {
  options.modules.services.system.searxng = {
    enable = lib.mkEnableOption "SearXNG";
    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8888;
    };
  };

  config = lib.mkIf cfg.enable {
    services.searx = {
      enable = true;
      redisCreateLocally = true;
      settings = {
        general = {
          instance_name = "SearXNG";
          donation_url = false;
          contact_url = false;
          privacypolicy_url = false;
          enable_metrics = true;
        };

        server = {
          inherit (cfg) port;
          base_url = "http://${cfg.address}:${toString cfg.port}";
          bind_address = cfg.address;
          public_instance = false;
          secret_key = "superdupersecretkey"; # not publicly accessible so idrc
        };
      };
    };
  };
}
