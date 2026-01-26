# Simple script to signal gpu-screen-recorder to save the replay buffer
# !! This requires modules.services.user.gsr-replay to be enabled and running !!
{writeShellApplication, ...}:
writeShellApplication {
  name = "gsr-replay-save";
  text = ''
    # Get gpu-screen-recorder PID
    PID=$(systemctl --user show --property MainPID --value gsr-replay.service)
    # gpu-screen-recorder handles SIGUSR1 as "Save replay buffer"
    kill -s SIGUSR1 $PID
  '';
}
