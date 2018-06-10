{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RecordWildCards #-}

-------------------------------------------------------------------------------
-- Imports                                                                  {{{
-------------------------------------------------------------------------------
import Data.Colour
import Data.Colour.SRGB
import Data.Colour.Solarized
import System.Taffybar
import System.Taffybar.Hooks
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget

import Text.Printf (printf)

--------------------------------------------------------------------------------
  -- Main                                                                    {{{
--------------------------------------------------------------------------------

main =
  -- startTaffybar
  dyreTaffybar
  $ withLogServer
  $ withToggleServer
  $ toTaffyConfig myConfig
    where
    ----------------------------------------------------------------------------
    myConfig = defaultSimpleTaffyConfig
      { barHeight = 24
      , barPosition = Top
      , widgetSpacing = 5
      , startWidgets =
        [ myWorkspaces
        , myLayout
        ]
      , endWidgets =
        [ myClock
        ]
      }
    ----------------------------------------------------------------------------
    -- Workspaces
    ----------------------------------------------------------------------------
    myWorkspaces = workspacesNew myWorkspacesConfig
      where
        myWorkspacesConfig = defaultWorkspacesConfig
          { maxIcons = Just 0
          , labelSetter = return . toLabel
          , showWorkspaceFn = myShowWorkspaceFn
          }

        toLabel :: Workspace -> String
        toLabel Workspace{..} =
          toColor workspaceState $ toIcon workspaceName
            where
              toColor :: WorkspaceState -> (String -> String)
              toColor = \case
                Active  -> colorizeFG blue
                Visible -> colorizeFG cyan
                Hidden  -> colorizeFG base0
                Empty   -> colorizeFG base0
                Urgent  -> colorizeFG red

              toIcon :: String -> String
              toIcon = \case
                "TERM"     -> fontAwesome  " \xf120 "
                "WEB"      -> fontAwesome' " \xf268 "
                "COM"      -> fontAwesome  " \xf086 "
                "WRK:TERM" -> fontAwesome  " \xf120 "
                "WRK:WEB"  -> fontAwesome' " \xf268 "
                "MEDIA"    -> fontAwesome' " \xf167 "
                "MONITOR"  -> fontAwesome  " \xf0f1 "
                "SYSTEM"   -> fontAwesome  " \xf085 "
                "TEMP"     -> fontAwesome  " \xf017 "
                _          -> ""

        myShowWorkspaceFn :: Workspace -> Bool
        myShowWorkspaceFn Workspace{..} =
          case workspaceName of
            "NSP" -> False
            _     -> True

    ----------------------------------------------------------------------------
    -- Layout
    ----------------------------------------------------------------------------
    myLayout = layoutNew myLayoutConfig
      where
        myLayoutConfig = defaultLayoutConfig
          { formatLayout = return . colorizeFG yellow
          }

    ----------------------------------------------------------------------------
    -- Clock
    ----------------------------------------------------------------------------
    myClock = textClockNew Nothing clockString 1

    clockString = dateString ++ "    " ++ timeString

    dateString = colorizeFG blue $
      fontAwesome "\xf073" ++ "  " ++ "%a %_d %b %Y  |  d.%j  w.%W"
    timeString = colorizeFG cyan $
      fontAwesome "\xf017" ++ "  " ++ "%H:%M:%S"

    ----------------------------------------------------------------------------
    -- Utils
    ----------------------------------------------------------------------------
    fontAwesome :: String -> String
    fontAwesome = printf "<span font_desc='Font Awesome 5 Free'>%s</span>"

    fontAwesome' :: String -> String
    fontAwesome' = printf "<span font_desc='Font Awesome 5 Brands'>%s</span>"

    colorizeFG :: Colour Double -> (String -> String)
    colorizeFG c = (colorize . sRGB24show) c ""

------------------------------------------------------------------------------}}}
---- Main                                                                     {{{
---------------------------------------------------------------------------------

--main = defaultTaffybar defaultTaffybarConfig
--  { startWidgets =
--    [ myPager
--    ]
--  , endWidgets =
--    [ mpris2New
--    , mprisNew defaultMPRISConfig
--    , myClock
--    , systrayNew
--    ]
--  }
--    where
--    ---------------------------------------------------------------------------
--    -- Pager
--    ---------------------------------------------------------------------------
--    myPager = taffyPagerNew myPagerConfig
--    myPagerConfig = defaultPagerConfig
--      { activeWindow = colorize blue "" . escape . shorten 40
--      , activeLayout = colorize yellow "" . escape
--      , activeWorkspace = colorize blue "" . toIcon
--      , hiddenWorkspace = colorize base0 "" . toIcon
--      , emptyWorkspace = colorize base0 "" .toIcon
--      , visibleWorkspace = colorize cyan "" . toIcon
--      , widgetSep = "    "
--      }

--    ---------------------------------------------------------------------------
--    -- Battery
--    ---------------------------------------------------------------------------

--    ---------------------------------------------------------------------------
--    -- Clock
--    ---------------------------------------------------------------------------

------------------------------------------------------------------------------}}}
