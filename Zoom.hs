module Zoom
where

-- Imports for GTK/Glade
import Graphics.UI.Gtk

import Data.IORef

import Refresh

-------------------------------------------------------------------------------
-- Zoom in works by expanding the current view such that the 
-- left hand edge of the original view remains at the same
-- position and the zoom in factor is 2.
-- For example, zoom into the time range 1.0 3.0
-- produces a new view with the time range 1.0 2.0

zoomIn :: IORef Double -> HScrollbar ->
           Statusbar -> ContextId -> DrawingArea
           -> IO ()
zoomIn scale profileHScrollbar statusbar ctx canvas
  = do scaleValue <- readIORef scale -- Double the scale value
       writeIORef scale (2*scaleValue)
       hadj <- rangeGetAdjustment profileHScrollbar -- Get horizontal scrollbar
       hadj_value <- adjustmentGetValue hadj -- Get position of bar
       hadj_pagesize <- adjustmentGetPageSize hadj -- Get size of bar
       hadj_upper <- adjustmentGetUpper hadj -- Get max value of scrollbar
       let maxVal = 2 * (hadj_upper - hadj_pagesize)
       adjustmentSetPageSize hadj (hadj_pagesize / 2)
       statusbarPush statusbar ctx ("Scale " ++ show (2*scaleValue))           
       refresh False canvas

-------------------------------------------------------------------------------
-- Zoom out works by contracting the current view such that the
-- left hand edge of the original view remains at the same
-- position and the zoom out factor is 2.
-- For example, zoom out of the time range 1.0 2.0
-- produces a new view with the time range 1.0 3.0

zoomOut :: IORef Double -> HScrollbar -> Statusbar -> ContextId -> DrawingArea
           -> IO ()
zoomOut scale profileHScrollbar statusbar ctx canvas
  = do scaleValue <- readIORef scale
       writeIORef scale (scaleValue/2)
       hadj <- rangeGetAdjustment profileHScrollbar
       hadj_value <- adjustmentGetValue hadj
       hadj_pagesize <- adjustmentGetPageSize hadj
       hadj_upper <- adjustmentGetUpper hadj
       adjustmentSetPageSize hadj (hadj_pagesize * 2)
       statusbarPush statusbar ctx ("Scale " ++ show (scaleValue/2))           
       refresh False canvas

-------------------------------------------------------------------------------
