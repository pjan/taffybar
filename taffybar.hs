{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
-------------------------------------------------------------------------------
-- Imports                                                                  {{{
-------------------------------------------------------------------------------
import System.Taffybar
import System.Taffybar.Battery
import System.Taffybar.Pager
import System.Taffybar.Systray
import System.Taffybar.SimpleClock
import System.Taffybar.TaffyPager
import System.Taffybar.MPRIS
import System.Taffybar.MPRIS2

import Text.Printf (printf)


----------------------------------------------------------------------------}}}
-- Theme                                                                    {{{
-------------------------------------------------------------------------------

base03  = "#002b37"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green   = "#859900"
black   = "#000000"
white   = "#ffffff"

----------------------------------------------------------------------------}}}
-- Main                                                                     {{{
-------------------------------------------------------------------------------

main = defaultTaffybar defaultTaffybarConfig
  { startWidgets =
    [ myPager
    ]
  , endWidgets =
    [ mpris2New
    , mprisNew defaultMPRISConfig
    , myClock
    , systrayNew
    ]
  }
    where
    ---------------------------------------------------------------------------
    -- Pager
    ---------------------------------------------------------------------------
    myPager = taffyPagerNew myPagerConfig
    myPagerConfig = defaultPagerConfig
      { activeWindow = colorize blue "" . escape . shorten 40
      , activeLayout = colorize yellow "" . escape
      , activeWorkspace = colorize blue "" . toIcon
      , hiddenWorkspace = colorize base0 "" . toIcon
      , emptyWorkspace = colorize base0 "" .toIcon
      , visibleWorkspace = colorize cyan "" . toIcon
      , widgetSep = "    "
      }

    toIcon :: String -> String
    toIcon s = case s of
                 "TERM"     -> fontAwesome  " \xf120 "
                 "WEB"      -> fontAwesome' " \xf268 "
                 "COM"      -> fontAwesome  " \xf086 "
                 "WRK:TERM" -> fontAwesome  " \xf120 "
                 "WRK:WEB"  -> fontAwesome' " \xf268 "
                 "MEDIA"    -> fontAwesome' " \xf167 "
                 "MONITOR"  -> fontAwesome  " \xf0f1 "
                 "SYSTEM"   -> fontAwesome  " \xf085 "
                 "TEMP"     -> fontAwesome  " \xf017 "
                 "NSP"      -> fontAwesome  ""
                 _          -> ""

    ---------------------------------------------------------------------------
    -- Battery
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    -- Clock
    ---------------------------------------------------------------------------
    myClock = textClockNew Nothing clockString 1

    clockString = dateString ++ "    " ++ timeString

    dateString = colorize blue "" $
      fontAwesome "\xf073" ++ "  " ++ "%a %_d %b %Y  |  d.%j  w.%W"
    timeString = colorize cyan "" $
      fontAwesome "\xf017" ++ "  " ++ "%H:%M:%S"

    ---------------------------------------------------------------------------
    -- Utils
    ---------------------------------------------------------------------------
    fontAwesome :: String -> String
    fontAwesome = printf "<span font_desc='Font Awesome 5 Free'>%s</span>"

    fontAwesome' :: String -> String
    fontAwesome' = printf "<span font_desc='Font Awesome 5 Brands'>%s</span>"

----------------------------------------------------------------------------}}}
