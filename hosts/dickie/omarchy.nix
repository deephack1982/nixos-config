{
  omarchy = {
    full_name = "Mark Dickie";
    email_address = "mark.dickie@gmail.com";
    theme = "tokyo-night";
    monitors = [ ",preferred,auto,1" ];
    terminal = "kitty";
    editor = "kitty hx";
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
      "SUPER, G, exec, $messenger"
      "SUPER, slash, exec, $passwordManager"
    ];
    kb_layout = "se";
  };
}
