{
  mkGraphicalSessionService = {
    description,
    path,
    execStart,
  }: {
    inherit path description;
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];

    serviceConfig = {
      ExecStart = execStart;
      Type = "simple";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
