module Main where

import Lib
import System.Environment

main :: IO ()
main = do args <- getArgs
          if length args > 1
          then swapColorThem (head args) (args !! 1)
          else swapColorThem "swap.bmp" "."
