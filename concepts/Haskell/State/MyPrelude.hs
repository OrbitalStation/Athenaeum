{-# LANGUAGE NoImplicitPrelude #-}

module MyPrelude where

import qualified Prelude
import qualified GHC.Show
import qualified GHC.Num
import qualified GHC.Num.Integer
import qualified GHC.Types
import qualified GHC.Classes
import qualified GHC.Base

type Unit = ()

unit :: Unit
unit = ()

identity :: a -> a
identity = \x -> x

flip2 :: (a -> b -> c) -> (b -> a -> c)
flip2 = \f a b -> f b a

fst :: (a, b) -> a
fst (a, _) = a

snd :: (a, b) -> b
snd (_, b) = b

const :: a -> b -> a
const = \a _ -> a

-- Haskell's `$`
infixr 0 <|
(<|) :: (a -> b) -> a -> b
(<|) = identity

-- Haskell's `&`
infixr 0 |>
(|>) :: a -> (a -> b) -> b
(|>) = flip2 identity

-- Haskell's `.`
infixl 2 ∘
(∘) :: (b -> c) -> (a -> b) -> (a -> c)
(∘) = \f g -> \x -> f (g x)

-- 2-composition
infixl 2 ∘∘
(∘∘) :: (a -> b) -> (c -> d -> a) -> c -> d -> b
(∘∘) = \f g -> \x -> f ∘ (g x)

-- 3-composition
infixl 2 ∘∘∘
(∘∘∘) :: (a -> b) -> (c -> d -> e -> a) -> c -> d -> e -> b
(∘∘∘) = \f g -> \x -> f ∘∘ (g x)

type IO = Prelude.IO
type Show = Prelude.Show
type Num = GHC.Num.Num
type Int = GHC.Types.Int
type Integer = GHC.Num.Integer.Integer
type String = GHC.Base.String

show :: Show a => a -> String
show = GHC.Show.show

infixl 6 +
(+) = (GHC.Num.+)

infixl 6 -
(-) = (GHC.Num.-)

infixl 7 *
(*) = (GHC.Num.*)

infix 4 <
(<) :: GHC.Classes.Ord a => a -> a -> GHC.Types.Bool
(<) = (GHC.Classes.<)

infix 4 >
(>) :: GHC.Classes.Ord a => a -> a -> GHC.Types.Bool
(>) = (GHC.Classes.>)

print :: Show a => a -> IO Unit 
print = Prelude.print

