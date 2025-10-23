{
  omarchy = {
    full_name = "Mark Dickie";
    email_address = "mark.dickie@gmail.com";
    theme = "tokyo-night";
    theme_overrides = {
      wallpaper_path = /home/markd/Pictures/Wallpapers/Internals13.jpeg;
    };
    monitors = [ "eDP-1,preferred,auto,1,vrr,1" "DP-4,preferred,auto-up,1,vrr,1" ];
    terminal = "kitty";
    editor = "zeditor";
    browser = "zen";
    quick_app_bindings = [
      "SUPER, C, exec, $webapp https://app.hey.com/calendar/weeks/"
      "SUPER, E, exec, $webapp https://app.hey.com"
      "SUPER, Y, exec, $webapp https://youtube.com/"
      "SUPER SHIFT, G, exec, $webapp https://web.whatsapp.com/"

      "SUPER, return, exec, $terminal"
      "SUPER SHIFT, F, exec, $fileManager"
      "SUPER, B, exec, $browser"
      "SUPER, M, exec, $webapp=https://music.youtube.com"
      "SUPER, N, exec, $editor"
      "SUPER SHIFT, N, exec, ~/.local/share/omarchy/bin/window-group.sh -g dev.zed.Zed"
      "SUPER, G, exec, $messenger"
      "SUPER, slash, exec, $passwordManager"
    ];
    kb_layout = "us";
  };
}
