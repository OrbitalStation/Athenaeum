{-# LANGUAGE NoImplicitPrelude #-}

module FluidState where

import GHC.Types (Bool (..))
import MyPrelude
import GHC.Base (Monad, pure, (>>))

class ParameterisedMonad m where
    ppure  :: a -> m s s a
    (>>>=) :: m s1 s2 t -> (t -> m s2 s3 a) -> m s1 s3 a

x >>> f = x >>>= const f

data State s1 s2 a = State (s1 -> (a, s2))

runState :: State s1 s2 a -> s1 -> (a, s2)
runState (State f) = f

instance ParameterisedMonad State where
    ppure  = \a -> State <| \s -> (a, s)
    (>>>=) = \m k -> State <| \s -> let (a, s') = runState m s in runState (k a) s'

get :: State s s s
get = State <| \s -> (s, s)

put :: s -> State s0 s Unit
put = \s -> State <| const (unit, s)

stateful = flip2 runState unit

while :: ParameterisedMonad m => m s1 s2 Bool -> m s2 s1 Unit -> m s1 s2 Unit
while = \cond body ->
    cond >>>= \doContinue -> if doContinue
        then body >>> while cond body
        else ppure unit

-- Join parameterised monads (IO + State)
-- Split State
factorial = \n -> fst <| snd <| stateful <|
    (>>>) (put (1, n)) <|
    while (get >>>= \(_, i) -> ppure (i > 1)) <|
        get >>>= \(result, i) ->
        put (result * i, i - 1)

factorialWithPrint = \n -> (\(io, (result, _)) -> io >> pure result) <| snd <| stateful <|
    (>>>) (put (pure unit, (1, n))) <|
    while (get >>>= \(_, (_, i)) -> ppure (i > 1)) <|
        get >>>= \(prevIO, (result, i)) ->
        put (prevIO >> print "hi", (result * i, i - 1))

