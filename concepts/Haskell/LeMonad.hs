import qualified Prelude

infixr 1 $
f $ x = f x

infixl 2 .
f . g = \x -> f $ g x

id x = x
flip f = \a b -> f b a

class LeHaskellFunctor f where
    fmap :: (a -> b) -> (f a -> f b)
    -- ...Plus functor laws

class LeHaskellFunctor m => LeHaskellMonad m where
    join :: m (m a) -> m a

    return :: a -> m a
    -- ...Plus monadic laws

    -- return >=> f === f
    -- f >=> return === f
    -- (f >=> g) >=> h === f >=> (g >=> h)

-- Kleisli-composition operator
(>=>) :: LeHaskellMonad m => (a -> m b) -> (b -> m c) -> (a -> m c)
(>=>) = \f g -> join . fmap g . f

-- Bind operator
(>>=) :: LeHaskellMonad m => m a -> (a -> m b) -> m b
(>>=) = \m f -> join $ fmap f m

data Option a = Some a | None
    deriving Prelude.Show

instance LeHaskellFunctor Option where
    fmap f (Some x) = Some $ f x
    fmap _ None     = None

instance LeHaskellMonad Option where
    join (Some x) = x
    join _        = None

    return = Some

main :: Prelude.IO ()
main = Prelude.print ""
