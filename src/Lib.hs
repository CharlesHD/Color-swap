module Lib
    ( swapColorThem
    ) where
import Data.List
import System.Directory
import Codec.Picture
import System.Info

dirSep :: String
dirSep = if os == "linux" then "/" else "\\"

isImage :: FilePath -> Bool
isImage p = any (`isSuffixOf` p) formats
        where formats = [".jpg", ".jpeg", ".png", ".gif"]

swapColorThem :: FilePath -> FilePath -> IO ()
swapColorThem palFile imgDir =
              do dynimg <- readImage palFile
                 files <- getDirectoryContents imgDir
                 let imgFiles = filter isImage files
                 imgs <- mapM readImage imgFiles
                 createDirectoryIfMissing True (imgDir ++ dirSep ++ "swap")
                 let res = do dimg <- dynimg
                              imgs' <- sequence imgs
                              let pal = convertRGB8 dimg
                              let pixmap = paletteToMap pal
                              let imgs'' = map (swapColorIt pixmap) imgs'
                              let name file = imgDir ++ dirSep ++ "swap" ++ dirSep ++ file ++ ".png"
                              let imgsWithNames = zip imgs'' imgFiles
                              return $ mapM_ (\(img, f) -> writePng (name f) img) imgsWithNames
                 either putStrLn id res

type PixMap = [(PixelRGB8, PixelRGB8)]

paletteToMap :: Palette -> PixMap
paletteToMap pal = [(pixelAt pal x 0, pixelAt pal x 1) | x <- [0.. (imageWidth pal) - 1]]

swapPixel :: PixMap -> PixelRGBA8 -> PixelRGBA8
swapPixel [] pix = pix
swapPixel ((PixelRGB8 a1 b1 c1, PixelRGB8 a2 b2 c2):xs) pix@(PixelRGBA8 a b c d) =
          if a1 == a && b1 == b && c1 == c
          then PixelRGBA8 a2 b2 c2 d
          else swapPixel xs pix

swapColorIt :: PixMap -> DynamicImage -> Image PixelRGBA8
swapColorIt p dynimg =
            let img = convertRGBA8 dynimg
            in pixelMap (swapPixel p) img
