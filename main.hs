import System.IO
import Control.Monad

main = do  
        contents <- readFile "main.hs"
        print . map readInt . words $ contents
-- alternately, main = print . map readInt . words =<< readFile "test.txt"

readInt :: String -> Int
readInt = read
