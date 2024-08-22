{-# LANGUAGE BlockArguments, TypeFamilies, UndecidableSuperClasses #-}

module Main where

import Prelude hiding (lookup, (!!))
import Data.Map
import Data.Maybe

type Unit = ()

unit :: Unit
unit = ()

infixl 9 !!
(!!) = \m k -> fromJust $ lookup k m

newtype State s a = State { runState :: s -> (a, s) } 

instance Functor (State s) where
    fmap :: (a -> b) -> State s a -> State s b
    fmap = \f a -> State $ \s -> let (a', s') = runState a s in (f a', s')

instance Applicative (State s) where
    pure  = \a -> State $ \s -> (a, s)
    (<*>) = \f a -> State $ \s ->
        let (f', s')  = runState f s  in
        let (a', s'') = runState a s' in
        (f' a', s'')

instance Monad (State s) where
    (>>=) = \m k -> State $ \s -> let (a, s') = runState m s in runState (k a) s'

type Key = String

data Cons d n = Cons d n

data Nil = Nil

class TNext (Next a) => TNext a where
    type Next a

instance TNext Nil where
    type Next Nil = Nil

instance TNext n => TNext (Cons d n) where
    type Next (Cons d n) = n

class GetSet a s where
    getValue :: s -> a
    setValue :: s -> a -> s

instance GetSet a (Cons a n) where
    getValue (Cons d _) = d
    setValue (Cons _ n) = flip Cons n 

instance GetSet a n => GetSet a (Cons b n) where
    getValue (Cons _ n) = getValue n
    setValue (Cons d n) = Cons d . setValue n 

get :: Key -> State (Map Key s) s
get = \label -> State $ \s -> (s !! label, s)

put :: Key -> s -> State (Map Key s) Unit
put = \label s -> State $ \old -> (unit, insert label s old)

stateful = flip runState empty

{-newtype STT state = STT { runSTT :: (ST state state, state -> ST state Unit) }

instance Functor STT where
    fmap :: (a -> b) -> STT a -> STT b
    fmap = \f a -> let (gt, pt) = runSTT a in (State $ \s -> let ())-}

{-instance Applicative (STT s) where
    pure :: a -> STT s a
    pure = \a -> STT (State $ \s -> (a, s), \s -> State $ \old -> ())-}

infiniteloop :: Monad m => m Bool -> m Unit
infiniteloop = \a -> do
    doBreak <- a
    if doBreak
        then return unit
        else infiniteloop a

factorial :: Integer -> Integer
factorial = \n -> flip (!!) "result" $ snd $ stateful do
    print "hi"
    put "result" 1
    put "i" n
    infiniteloop do
        i <- get "i"
        if not (i > 0) then return True else do
            result <- get "result"
            put "result" (result * i)
            put "i" (i - 1)
            return False

main :: IO Unit
main = print $ factorial 10

