{-# LANGUAGE NoImplicitPrelude, TypeFamilies, DataKinds, KindSignatures, ExplicitForAll #-}

module State where

import GHC.Types (Bool(..))
import qualified GHC.Base
import MyPrelude
import Monad
import Loop

data State s a = State (s -> (a, s))

runState :: State s a -> s -> (a, s)
runState (State f) = f

instance Functor (State s) where
    fmap = \f a -> State <| \s -> let (a', s') = runState a s in (f a', s')

instance Monad (State s) where
    pure = \a -> State <| \s -> (a, s)
    join = \state -> State <| \s -> let (a, s') = runState state s in runState a s'

get :: State s s
get = State <| \s -> (s, s)

put :: s -> State s Unit
put = \a -> State <| const (unit, a)

data SRCons (name :: GHC.Base.Symbol) d next = SRCons d next

data SRNil = SRNil

type family SRTypeOf a (name :: GHC.Base.Symbol) where
    SRTypeOf (SRCons name d next) name = d
    SRTypeOf (SRCons name d next) name' = SRTypeOf next name'

class SRGetSet where
    gett :: State s (SRTypeOf (SRCons name d next) name')

factorial = \n -> fst <| snd <| flip2 runState (0, 0) <|
    (>>) (put (1, n)) <|
    while (get >>= \(_, i) -> pure (i > 1)) <|
        get >>= \(result, i) ->
        put (result * i, i - 1)

factorialWithPrint = \n -> (\(io, (result, _)) -> (GHC.Base.>>) io (GHC.Base.pure result)) <| snd <| flip2 runState (GHC.Base.pure unit, (0, 0)) <|
    (>>) (put (GHC.Base.pure unit, (1, n))) <|
    while (get >>= \(_, (_, i)) -> pure (i > 1)) <|
        get >>= \(io, (result, i)) ->
        put ((GHC.Base.>>) io (print "hi"), (result * i, i - 1))

