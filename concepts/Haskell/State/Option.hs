{-# LANGUAGE NoImplicitPrelude #-}

module Option where

import MyPrelude
import Monad

data Option a = Some a | None
    deriving Show

instance Functor Option where
    fmap f (Some a) = Some (f a)
    fmap f None     = None

instance Monad Option where
    pure = Some
    join (Some x) = x
    join None     = None

