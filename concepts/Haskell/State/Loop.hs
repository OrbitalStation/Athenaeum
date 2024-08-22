{-# LANGUAGE NoImplicitPrelude #-}

module Loop where

import GHC.Types (Bool)
import MyPrelude
import Monad

while :: Monad m => m Bool -> m Unit -> m Unit
while = \cond body ->
    cond >>= \doContinue -> if doContinue
        then body >> while cond body
        else pure unit

