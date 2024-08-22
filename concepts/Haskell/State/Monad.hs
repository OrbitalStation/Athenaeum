{-# LANGUAGE NoImplicitPrelude #-}

module Monad where

import MyPrelude

class Functor f where
    fmap :: (a -> b) -> f a -> f b

class Functor m => Monad m where
    pure :: a -> m a
    join :: m (m a) -> m a

infixl 1 >>=
(>>=) :: Monad m => m a -> (a -> m b) -> m b
(>>=) = join ∘∘ flip2 fmap

infixl 1 >>
(>>) :: Monad m => m a -> m b -> m b
(>>) = flip2 <| flip2 (>>=) ∘ const

