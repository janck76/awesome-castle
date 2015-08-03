local awful = require("awful")

function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then 
        --awful.util.spawn_with_shell("zenity --info --text '" .. prg .. "'")
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
--       awful.util.spawn_with_shell("zenity --info --title $USER --text '" .. prg ..  " " .. arg_string .. "'")
--       awful.util.spawn_with_shell("ps -eo args -u $USER | grep '" .. pname .. " ".. arg_string .."' |grep -v ^grep >>/tmp/spawn 2>&1",screen)
--       awful.util.spawn_with_shell("ps -eo args -u $USER | grep '" .. pname .. " ".. arg_string .."' |grep -v ^grep || (" .. prg .. " " ..arg_string .. ")",screen)
       awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. " ".. arg_string .."' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end


function run_startup(c)
    home = os.getenv("HOME")

    run_once("urxvtd")
    
    script=home .. "/scripts/urxvt_tmux.sh"
--    run_once(script,nil,"/bin/bash - " .. script)
   
    run_once("sudo nvidia.sh","off")
--    run_once("syndaemon","-k -i 2 -d")
    run_once("syndaemon","-t -k -i 2 -d")
    run_once("firefox")
    run_once("insync","start")
   
    script=home .. "/scripts/devmon_e05c-5865.sh"
    run_once(script,nil,"/bin/bash - " .. script)
   
    run_once("parcimonie.sh",nil,"bash /usr/bin/parcimonie.sh")

    script=home .. "/scripts/pkgupdates.pl"
    run_once(script,nil,"/usr/bin/perl " .. script)

--  Ikke bruk ~  - bruk  full path til homedir !!!!
--    run_once("urxvt","-title tmux -e /home/janck/.tmux/4panes_sudo.sh")


--    run_once("xterm","-e sudo su -")
--    Client focus problem https://github.com/copycat-killer/awesome-copycats/issues/39
--    run_once("xcompmgr","-CcfF")
--    run_once("chromium",nil,"/usr/lib/chromium/chromium")
--  Automounts and unmounts optical and removable drives
--     `" i kommandolinje funker dårlig

--    run_once("mopidy")
-- Refresh your GnuPG keyring without disclosing your whole contact list to the world
end

function global_keys(c)
    -- {{{ Key bindings
    globalkeys = awful.util.table.join(
        awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
        awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
        awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

        awful.key({ modkey,           }, "j",
            function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
            end),
        awful.key({ modkey,           }, "k",
            function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
            end),
        awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

        -- Layout manipulation
        awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
        awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
        awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
        awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
        awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
        awful.key({ modkey,           }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end),

        -- Standard program
        awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
        awful.key({ modkey, "Control" }, "r", awesome.restart),
        awful.key({ modkey, "Shift"   }, "q", awesome.quit),

        awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
        awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
        awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
        awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
        awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
        awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
        awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
        awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

        awful.key({ modkey, "Control" }, "n", awful.client.restore),

        -- Prompt
        awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

        awful.key({ modkey }, "x",
                  function ()
                      awful.prompt.run({ prompt = "Run Lua code: " },
                      mypromptbox[mouse.screen].widget,
                      awful.util.eval, nil,
                      awful.util.getdir("cache") .. "/history_eval")
                  end),
        -- Menubar
        awful.key({ modkey }, "p", function() menubar.show() end)
    )
end

function client_keys(c)
    clientkeys = awful.util.table.join(
        awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
        awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
        awful.key({ altl,   }, "F4",      function (c) c:kill()                         end),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
        awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
        awful.key({ modkey,           }, "'",      function (c) c.ontop = not c.ontop            end),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical   = not c.maximized_vertical
            end),
        awful.key({ modkey, altl      }, "l",
            function() 
                awful.util.spawn_with_shell("xscreensaver-command --lock")
            end),
        awful.key({                   }, "Print",
            function() 
                awful.util.spawn_with_shell("/usr/bin/scrot ~/scrot/%Y-%m-%d-%s_$wx$h_scrot.png -e 'geeqie $f 2>/dev/null &'")
            end),
        awful.key({ modkey,           }, "Print",
            function() 
                awful.util.spawn_with_shell("sleep 1; /usr/bin/scrot ~/scrot/%Y-%m-%d-%s_$wx$h_scrot.png -s -e 'geeqie $f 2>/dev/null &'")
            end)
    )
end


function mouse_bindings(c)
    -- {{{ Mouse bindings
    root.buttons(awful.util.table.join(
        awful.button({ }, 3, function () mymainmenu:toggle() end),
        awful.button({ }, 4, awful.tag.viewnext),
        awful.button({ }, 5, awful.tag.viewprev)
    ))
    -- }}}
end
