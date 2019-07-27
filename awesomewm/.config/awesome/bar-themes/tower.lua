local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = require('beautiful').xresources.apply_dpi
local separators = require('util.separators')
local widget = require('util.widgets')

-- colors
local primary_dark = beautiful.primary_dark
local fg_primary = beautiful.fg_primary_focus

-- widgets load
--local hostname = require("widgets.hostname")
local tor = require("widgets.button_tor")
--local text_taglist = require("widgets.mini_taglist")
local scrot = require("widgets.scrot")
local scrot_circle = widget.circle(scrot, beautiful.grey, beautiful.primary)

--local network = require("widgets.network")
--local wifi_str = require("widgets.wifi_str")
local pad = separators.pad

-- {{{ Redefine widgets with a background

local mpc = require("widgets.button_only_mpc")

local mail = require("widgets.mail")
local mail_bg = beautiful.widget_battery_bg
local my_mail = widget.bg(mail_bg, mail)

--local ram = require("widgets.ram")
--local ram_bg = beautiful.widget_ram_bg
--local my_ram = ram_widget

--local battery = require("widgets.battery")
--local bat_bg = beautiful.widget_battery_bg
--local my_battery = battery_widget

--local date = require("widgets.date")
--local date_bg = beautiful.widget_date_bg
--local my_date = date_widget

local my_menu = require("menu")
local launcher = awful.widget.launcher(
  { image = beautiful.awesome_icon, menu = my_menu }
)

--local network_monitor = require("widgets.network_monitor")
--local my_network_monitor = network_monitor_widget

-- {{{ Define music block
--local network_icon = widget.for_one_icon(fg_primary, primary_dark," 旅 ","Iosevka Term 16")

--  my_network_monitor,
--  network_icon,
--  my_mail,
--  my_ram,
--  my_battery,
--  my_date,
--  spacing = dpi(9),
-- }}} End Define other block

-- Remove space between taglist icon
local tagslist = require("widgets.text_taglist_with_shape")
local my_tagslist = tagslist

-- widget redefined }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
  local instance = nil

  return function() 
    if instance and instance.wibox.visible then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ theme = { width = 250 } })
    end
  end
end
-- }}}

-- {{{ Wibar

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      -- Without this, the following
      -- :isvisible() makes no sense
      c.minimized = false
      if not c:isvisible() and c.first_tag then
        c.first_tag:view_only()
      end
      -- This will also un-minimize
      -- the client, if needed
      client.focus = c
      c:raise()
    end
  end),
  awful.button({ }, 3, client_menu_toggle_fn()),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
  end))

-- Add the bar on each screen
awful.screen.connect_for_each_screen(function(s)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function () awful.layout.inc( 1) end),
    awful.button({}, 3, function () awful.layout.inc(-1) end),
    awful.button({}, 4, function () awful.layout.inc( 1) end),
    awful.button({}, 5, function () awful.layout.inc(-1) end)
  ))

  -- Create a tasklist widget
  --s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)
  s.mytasklist = awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    widget_template = {
      {
        {
          {
            {
              id     = 'icon_role',
              widget = wibox.widget.imagebox,
            },
            margins = 0,
            widget  = wibox.container.margin,
          },
        {
          id     = 'text_role',
          widget = wibox.widget.textbox,
        },
        layout = wibox.layout.fixed.horizontal,
      },
      left  = 5,
      right = 5,
      top = 5,
      bottom = 5,
      widget = wibox.container.margin
    },
    id     = 'background_role',
    forced_width = dpi(60),
    widget = wibox.container.background,
  },
}

-- Create the wibox with default options
s.mywibox = awful.wibar({ position = beautiful.wibar_position, bg = beautiful.wibar_bg })

-- Add widgets to the wibox
s.mywibox:setup {
  {
    mpc,
    tor,
    my_mail,
    layout = wibox.layout.fixed.horizontal
  },
  {
    {
      my_tagslist,
      top = 2,
      bottom = 5,
      widget = wibox.container.margin
    },
    layout = wibox.layout.fixed.horizontal
  },
  {
    scrot_circle,
    layout = wibox.layout.fixed.horizontal
  },
  expand = "none",
  layout = wibox.layout.align.horizontal
}
end)
